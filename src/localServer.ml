module type Kernel = sig
  type state

  val init : unit -> state
  val start_simulation : string -> string -> state ->
    [ `OK | `DoesNotCompile | `AlreadyRunning ]
  val query : int -> state -> string
end

module Make (K: Kernel) = struct
  open ServerCore

  (** [current_state] records the current mutable state of local server. *)
  let current_state = K.init ()

  (**
   * [handle_start_simulation_request _ body] handles the start simulation
   * request with the given [body].
   *
   * Requires: [body] contains black and white program in JSON format.
   * @return server response.
  *)
  let handle_start_simulation_request _ (body: string) : string =
    let open Yojson.Basic in
    let open Util in
    let (black_program, white_program) =
      try
        let assoc = body |> from_string |> to_assoc in
        let to_string key = assoc |> List.assoc key |> to_string in
        (to_string "black_program", to_string "white_program")
      with _ -> report_bad_input "Bad start simulation request!"
    in
    match K.start_simulation black_program white_program current_state with
    | `OK -> "OK"
    | `DoesNotCompile -> "DOES_NOT_COMPILE"
    | `AlreadyRunning -> "ALREADY_RUNNING"

  (**
   * [handle_query_request params] handles the query request with the given
   * [params].
   *
   * Requires: [params] should contain an int [round_id].
   * @return server response.
  *)
  let handle_query_request (param: params) _ : string =
    let id =
      try param |> List.assoc "round_id" |> int_of_string
      with _ -> report_bad_input "Round ID must be int!"
    in
    K.query id current_state

  (** [handlers] contains a list of defined handlers. *)
  let handlers = [
    create_handler POST "/apis/local/start_simulation"
      handle_start_simulation_request;
    create_handler GET "/apis/local/query" handle_query_request;
  ]

  let start_local_server () = start_server handlers
end
