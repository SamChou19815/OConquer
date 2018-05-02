module type Kernel = sig
  type state

  val init : unit -> state
  val register : string -> string -> state -> int option
  val sign_in : string -> string -> state -> int option
  val submit_programs : int -> string -> string -> bool
  val query_match : int -> int -> string option
  val score_board : state -> string
end

module Make (K: Kernel) = struct
  let start_remote_server () : unit = ()
end
