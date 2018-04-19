open Lwt
open Cohttp
open Cohttp_lwt_unix

module type Kernel = sig
  type state

  val init : unit -> state
  val start_simulation : string -> string -> state ->
    [ `OK | `DoesNotCompile | `AlreadyRunning ]
  val query : int -> state -> string
end

module Make (K: Kernel) = struct
  open ServerCore

  let current_state = K.init ()

  let handle_start_simulation_request _ (body: string) : string =
    (* TODO better parsing body method *)
    match String.split_on_char ';' body with
    | [p1; p2] -> begin
        match K.start_simulation p1 p2 current_state with
        | `OK -> "OK"
        | `DoesNotCompile -> "DOES_NOT_COMPILE"
        | `AlreadyRunning -> "ALREADY_RUNNING"
      end
    | _ -> report_bad_input "Bad start simulation request!"

  let handle_query_request (param: params) _ : string =
    let id =
      try param |> List.assoc "round_id" |> int_of_string
      with _ -> report_bad_input "Round ID must be int!"
    in
    K.query id current_state

  let handlers = [
    create_handler POST "/apis/local/start_simulation"
      handle_start_simulation_request;
    create_handler GET "/apis/local/query" handle_query_request;
  ]

  let start_local_server () = start_server handlers
end
