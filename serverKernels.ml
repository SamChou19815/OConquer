open Data

(** [LocalServerKernel] is the kernal of local server. *)
module LocalServerKernel : LocalServer.Kernel = struct
  (* TODO fix all dummy implementation! *)
  type state = unit

  let init () = ()
  let start_simulation _ _ () = `OK
  let query _ () = ()
end
