module type Kernel = sig
  type state

  val init : unit -> state
  val register : string -> string -> state -> int option
  val sign_in : string -> string -> state -> int option
  val submit_programs : int -> string -> string -> state -> bool
  val query_match : int -> int -> state -> string option
  val score_board : state -> string
end

module Make (K: Kernel) = struct
  open ServerCore
  open Yojson.Basic
  open Util

  (** [current_state] records the current mutable state of remote server. *)
  let current_state = K.init ()

  (**
   * [assoc body] turns body into simple json assoc list.
   *
   * Requires: [body] must have an assoc json format.
   * @return assoc list built from [body].
  *)
  let assoc (body: string) : (string * json) list =
    body |> from_string |> to_assoc

  (**
   * [handle_echo_request _ _] simply prints OK to indicate there is a server
   * with this address.
   *
   * Requires: None.
   * @return ["OK"].
  *)
  let handle_echo_request _ _ : string = "OK"

  (**
   * [handle_register_request _ body] handles the register request with the
   * given [body].
   *
   * Requires: [body] contains registration info in JSON format.
   * @return server response.
  *)
  let handle_register_request _ (body: string) : string =
    let (username, password) =
      try
        let assoc = assoc body in
        let to_string key = assoc |> List.assoc key |> to_string in
        (to_string "username", to_string "password")
      with _ -> report_bad_input "Bad register request!"
    in
    match K.register username password current_state with
    | None -> "USERNAME_USED"
    | Some token -> string_of_int token

  (**
   * [handle_sign_in_request _ body] handles the sign in request with the
   * given [body].
   *
   * Requires: [body] contains signing in info in JSON format.
   * @return server response.
  *)
  let handle_sign_in_request _ (body: string) : string =
    let (username, password) =
      try
        let assoc = assoc body in
        let to_string key = assoc |> List.assoc key |> to_string in
        (to_string "username", to_string "password")
      with _ -> report_bad_input "Bad sign in request!"
    in
    match K.sign_in username password current_state with
    | None -> "BAD_CREDENTIAL"
    | Some token -> string_of_int token

  (**
   * [handle_submit_programs_request params body] handles the submit program
   * request with the given [params] and [body].
   *
   * Requires:
   * - [params] should contain an int token.
   * - [body] should contain black and white programs.
   * @return server response.
  *)
  let handle_submit_programs_request (params: params) (body: string) : string =
    let token =
      try params |> List.assoc "token" |> int_of_string
      with _ -> report_bad_input "Bad token!"
    in
    let (black_program, white_program) =
      try
        let assoc = assoc body in
        let to_string key = assoc |> List.assoc key |> to_string in
        (to_string "black_program", to_string "white_program")
      with _ -> report_bad_input "Bad submit program request!"
    in
    if K.submit_programs token black_program white_program current_state then
      "OK"
    else "DOES_NOT_COMPILE"

  (**
   * [handle_query_request params] handles the query request with the given
   * [params].
   *
   * Requires: [params] should contain an int [token] and int [round_id].
   * @return server response.
  *)
  let handle_query_request (params: params) _ : string =
    let (token, id) =
      try
        (params |> List.assoc "token" |> int_of_string,
         params |> List.assoc "round_id" |> int_of_string)
      with _ -> report_bad_input "Bad token or round_id."
    in
    match K.query_match token id current_state with
    | Some s -> s
    | None -> "NOT_AVAILABLE"

  (**
   * [handle_score_board_request _ _] handles the score board request.
   *
   * Requires: None.
   * @return server response.
  *)
  let handle_score_board_request _ _ : string = K.score_board current_state

  (** [handlers] contains a list of defined handlers. *)
  let handlers = [
    create_handler GET "/apis/remote/echo" handle_echo_request;
    create_handler POST "/apis/remote/register" handle_register_request;
    create_handler POST "/apis/remote/sign_in" handle_sign_in_request;
    create_handler POST "/apis/remote/submit_programs"
      handle_submit_programs_request;
    create_handler GET "/apis/remote/query" handle_query_request;
    create_handler GET "/apis/remote/score_board" handle_score_board_request;
  ]

  let start_remote_server () : unit = start_server ~port:8088 handlers

end
