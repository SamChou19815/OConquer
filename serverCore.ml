open Lwt
open Cohttp
open Cohttp_lwt_unix

type accepted_method = GET | POST

type params = (string * string list) list

type convenient_handler = params -> string -> string

type handler = Server.conn -> Request.t -> (string -> string) option

(**
 * [response] is the type of the response given to the client.
 * This type is an low-level implementation and should be hidden from clients.
*)
type response = (Response.t * Cohttp_lwt__Body.t) Lwt.t

(** [callback] is a low level function used by cohttp to handle requests. *)
type callback = Server.conn -> Request.t -> Cohttp_lwt__Body.t -> response

let create_handler (m: accepted_method) (path: string)
    (h: convenient_handler) : handler =
  fun (conn: Server.conn) (req: Request.t) : (string -> string) option ->
    (* Only accept GET or POST *)
    let method_opt = match Request.meth req with
      | `GET -> Some GET
      | `POST -> Some POST
      | _ -> None
    in
    match method_opt with
    (* Refuse to handle unknown methods *)
    | None -> None
    | Some m' ->
      (* Refuse to handle wrong methods *)
      if m <> m' then None
      else
        let uri = Request.uri req in
        (* Refuse to handle wrong paths. *)
        if Uri.path uri = path then Some (h (Uri.query uri)) else None

let test_handler : handler = create_handler GET "/test" (fun _ b -> "It works!")

(**
 * [create_callback handlers] automatically creates a callback that can be used
 * by the server that can handle requests.
 *
 * Requires: None.
 * Returns: a callback that handle requests according to given [handlers].
*)
let create_callback (handlers: handler list) : callback =
  let rec handle (lst: handler list) (conn: Server.conn)
      (req: Request.t) (body: Cohttp_lwt__Body.t) : response =
    match lst with
    (* Case 1: No handler can handle this request, give a 404 error. *)
    | [] -> Server.respond_error ~status:`Not_found ~body:"Not Found" ()
    | h::others ->
      match h conn req with
      (* If cannot handle, move on to the next ones. *)
      | None -> handle others conn req body
      | Some body_handler ->
        (* Handle the request.
         * It does the dirty callback hell for the clients. *)
        body |> Cohttp_lwt.Body.to_string >>= (fun b ->
            try
              let resp_body = body_handler b in
              Server.respond_string
                ~status:`OK ~body:resp_body ()
            with _ ->
              Server.respond_error
                ~status:`Internal_server_error
                ~body:"Internal Error" ()
          )
  in
  handle handlers

let start_server ?(port: int = 8080) (handlers: handler list) : unit =
  (* Adapted from cohttp tutorial in its README. *)
  let mode = `TCP (`Port port) in
  let callback = create_callback handlers in
  let server = Server.create ~mode (Server.make ~callback ()) in
  ignore (Lwt_main.run server)
