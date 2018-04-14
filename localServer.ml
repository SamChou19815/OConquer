open Lwt
open Cohttp
open Cohttp_lwt_unix

let start_simulation (p1: Command.program) (p2: Command.program) : unit = ()

let query (round_id: int) : WorldMap.t = failwith "Unimplemented"

let delegate (cmd: string) : unit = ()

let start_local_server () = let open ServerCore in start_server [test_handler]
