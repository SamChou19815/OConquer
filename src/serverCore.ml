open Lwt
open Cohttp
open Cohttp_lwt_unix

type accepted_method = GET | POST | OPTIONS

type params = (string * string) list

type convenient_handler = params -> string -> string

(** [BadInput reason] indicates a reason for bad inputs. *)
exception BadInput of string

type handler = Server.conn -> Request.t -> (string -> string) option

(**
 * [response] is the type of the response given to the client.
 * This type is an low-level implementation and should be hidden from clients.
*)
type response = (Response.t * Cohttp_lwt__Body.t) Lwt.t

(** [callback] is a low level function used by cohttp to handle requests. *)
type callback = Server.conn -> Request.t -> Cohttp_lwt__Body.t -> response

let report_bad_input (reason: string) : 'a = raise (BadInput reason)

(**
 * [query_simplifier raw_params] collapses the list of values into one, dropping
 * additional values if needed.
 *
 * Requires: [raw_params] is the raw params directly from Cohttp.
 * @return an association list of simplified params.
*)
let query_simplifier : (string * string list) list -> params =
  let rec h acc = function
    | [] -> acc
    | (key, values)::others ->
      match values with
      | [] -> h acc others
      | first_value::_ ->
        let pair = (key, first_value) in
        let acc' = pair::acc in
        h acc' others
  in
  h []

(** [common_header] is the common header used by all requests. *)
let common_header : Cohttp.Header.t =
  let open Cohttp.Header in
  let add key value h = add h key value in
  init ()
  |> add "Access-Control-Allow-Origin" "*"
  |> add
    "Access-Control-Allow-Headers"
    "Content-Type, Authorization, X-Requested-With"
  |> add "Access-Control-Allow-Methods" "GET, POST, OPTIONS"
  |> add "Access-Control-Allow-Credentials" "true"
  |> add "Vary" "Origin"

let create_handler (m: accepted_method) (path: string)
    (h: convenient_handler) : handler =
  fun (conn: Server.conn) (req: Request.t) : (string -> string) option ->
    (* Only accept GET or POST *)
    let method_opt = match Request.meth req with
      | `GET -> Some GET
      | `POST -> Some POST
      | `OPTIONS -> Some OPTIONS
      | _ -> None
    in
    match method_opt with
    (* Refuse to handle unknown methods *)
    | None -> None
    | Some m' ->
      if m' = OPTIONS then Some (fun _ -> "OK") (* Deal with CORS *)
      else if m <> m' then None (* Refuse to handle wrong methods *)
      else (
        let uri = Request.uri req in
        (* Refuse to handle wrong paths. *)
        if Uri.path uri = path then
          Some (uri |> Uri.query |> query_simplifier |> h)
        else None
      )

let test_handler : handler = create_handler GET "/test" (fun _ _ -> "It works!")

(**
 * [create_callback handlers] automatically creates a callback that can be used
 * by the server that can handle requests.
 *
 * Requires: None.
 * @return a callback that handle requests according to given [handlers].
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
                ~headers:common_header
                ~status:`OK
                ~body:resp_body ()
            with
            | BadInput reason ->
              Server.respond_error
                ~headers:common_header
                ~status:`Bad_request (* 400 error. *)
                ~body:("Bad Input. Reason: \n" ^ reason) ()
            | _ ->
              Server.respond_error
                ~headers:common_header
                ~status:`Internal_server_error (* 500 error. *)
                ~body:"Internal Error." ()
          )
  in
  handle handlers

let start_server ?(port: int = 8080) (handlers: handler list) : unit =
  (* Adapted from cohttp tutorial in its README. *)
  let mode = `TCP (`Port port) in
  let callback = create_callback handlers in
  let server = Server.create ~mode (Server.make ~callback ()) in
  let () =
    print_endline ("Server started at http://localhost:" ^ string_of_int port)
  in
  ignore (Lwt_main.run server)
