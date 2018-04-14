open Lwt
open Cohttp
open Cohttp_lwt_unix

type accepted_method = GET | POST

type params = (string * string list) list

type response = (Response.t * Cohttp_lwt__Body.t) Lwt.t

type convenient_handler = params -> string -> response

type handler = Server.conn -> Request.t -> (string -> response) option

(** [callback] is a low level function used by cohttp to handle requests. *)
type callback = Server.conn -> Request.t -> Cohttp_lwt__Body.t -> response

let create_handler (m: accepted_method) (path: string)
    (h: convenient_handler) : handler =
  fun (conn: Server.conn) (req: Request.t) : (string -> response) option -> (
      let method_opt = match Request.meth req with
        | `GET -> Some GET
        | `POST -> Some POST
        | _ -> None
      in
      match method_opt with
      | None -> None
      | Some m' ->
        if m <> m' then None
        else
          let uri = Request.uri req in
          if Uri.path uri = path then Some (h (Uri.query uri)) else None
    )

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
    | [] -> Server.respond_error ~status:`Not_found ~body:"Not found" ()
    | h::others ->
      match h conn req with
      | None -> handle others conn req body
      | Some body_handler ->
        body |> Cohttp_lwt.Body.to_string >>= body_handler
  in
  handle handlers

let start_server ?(port: int = 8080) (handlers: handler list) : unit =
  let mode = `TCP (`Port port) in
  let callback = create_callback handlers in
  let server = Server.create ~mode (Server.make ~callback ()) in
  ignore (Lwt_main.run server)
