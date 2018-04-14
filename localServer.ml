open Lwt
open Cohttp
open Cohttp_lwt_unix

let start_simulation (p1: Command.program) (p2: Command.program) : unit = ()

let query (round_id: int) : WorldMap.t = failwith "Unimplemented"

let delegate (cmd: string) : unit = ()

type accepted_method = GET | POST

type params = (string * string list) list

type response = (Response.t * Cohttp_lwt__Body.t) Lwt.t

type convenient_handler = params -> string -> response

type callback = Server.conn -> Request.t -> Cohttp_lwt__Body.t -> response

type handler = Server.conn -> Request.t -> (string -> response) option

let handler_producer (m: accepted_method) (path: string)
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

let create_callback (handler_lst: handler list) : callback =
  let rec handle (handler_lst: handler list) (conn: Server.conn)
      (req: Request.t) (body: Cohttp_lwt__Body.t) : response =
    match handler_lst with
    | [] -> Server.respond_error ~status:`Not_found ~body:"Not found" ()
    | h::others ->
      match h conn req with
      | None -> handle others conn req body
      | Some body_handler ->
        body |> Cohttp_lwt.Body.to_string >>= body_handler
  in
  handle handler_lst

let server : unit Lwt.t =
  let test_handler = handler_producer GET "/test" (fun _ b ->
      let body =
        Printf.sprintf "UriPath: %s\nMethod: %s\nBody: %s" "/test" "GET" b
      in
      Server.respond_string ~status:`OK ~body ()
    )
  in
  let callback = create_callback [test_handler]
  in
  Server.create ~mode:(`TCP (`Port 8080)) (Server.make ~callback ())

let start_local_server () = ignore (Lwt_main.run server)
