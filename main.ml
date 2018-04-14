open Engine
open RemoteServer

(*
 * Mainly responsible for connecting different parts of the application.
 * Once those parts are finished, the implementation of main should be trivial.
*)

module LocalServer = LocalServer.Make (ServerKernels.LocalServerKernel)

let main () = LocalServer.start_local_server ()

let () = main ()
