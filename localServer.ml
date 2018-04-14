open Lwt
open Cohttp
open Cohttp_lwt_unix

module type Kernel = sig
  type state

  val init : unit -> state
  val start_simulation : string -> string -> state ->
    [ `OK | `DoesNotCompile | `AlreadyRunning ]
  val query : int -> state -> unit
end

module Make (K: Kernel) = struct
  (* TODO fix dummy implementation *)
  let start_local_server () = let open ServerCore in start_server [test_handler]
end
