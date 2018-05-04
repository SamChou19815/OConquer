open Engine
open RemoteServer

(*
 * Mainly responsible for connecting different parts of the application.
 * Once those parts are finished, the implementation of main should be trivial.
*)

module LocalServer = LocalServer.Make (ServerKernels.LocalServerKernel)
module RemoteServer = RemoteServer.Make (ServerKernels.RemoteServerKernel)

(** [print_usage ()] helps to print the usage of program. *)
let print_usage () =
  let () = print_endline "Usage:" in
  let () = print_endline " - Start Local Server: ./main.byte local" in
  let () = print_endline " - Start Remote Server: ./main.byte remote" in
  let () = print_endline " - Get Help: ./main.byte -help" in
  print_endline ""

(** [main] is the entrance function. *)
let main (args: string array) =
  if Array.length args = 0 then print_usage ()
  else
    match args.(0) with
    | "local" -> LocalServer.start_local_server ()
    | "remote" -> RemoteServer.start_remote_server ()
    | _ -> print_usage ()

let () = main Sys.argv
