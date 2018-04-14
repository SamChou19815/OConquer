open Lwt
open Cohttp
open Cohttp_lwt_unix

let start_simulation (p1: Command.program) (p2: Command.program) : unit = ()

let query (round_id: int) : WorldMap.t = failwith "Unimplemented"

let delegate (cmd: string) : unit = ()

let start_local_server () =
  let test_handler = ServerCore.create_handler GET "/test" (fun _ b ->
      let body =
        Printf.sprintf "UriPath: %s\nMethod: %s\nBody: %s" "/test" "GET" b
      in
      Server.respond_string ~status:`OK ~body ()
    )
  in
  ServerCore.start_server [test_handler]
