open Lwt
open Cohttp
open Cohttp_lwt_unix

let start_simulation (p1: Command.program) (p2: Command.program) : unit = ()

let query (round_id: int) : WorldMap.t = failwith "Unimplemented"

let delegate (cmd: string) : unit = ()

let server : unit Lwt.t =
  let callback _conn req body =
    let uri = req |> Request.uri |> Uri.to_string in
    let meth = req |> Request.meth |> Code.string_of_method in
    let headers = req |> Request.headers |> Header.to_string in
    body |> Cohttp_lwt.Body.to_string >|= (fun body ->
        (Printf.sprintf "Uri: %s\nMethod: %s\nHeaders\nHeaders: %s\nBody: %s"
           uri meth headers body))
    >>= (fun body -> Server.respond_string ~status:`OK ~body ())
  in
  Server.create ~mode:(`TCP (`Port 8000)) (Server.make ~callback ())

let start_local_server () = ignore (Lwt_main.run server)
