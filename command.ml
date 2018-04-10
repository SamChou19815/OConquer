open Definitions
open Common

type program = string

module type Context = sig
  val get_my_pos : Position.t
  val get_mil_unit : Position.t -> MilUnit.t option
  val get_tile : Position.t -> Tile.t
end

let from_string (i: player_identity) (p_str: string) : program option =
  let class_name = match i with
    | Black -> "BlackProgram"
    | White -> "WhiteProgram"
  in
  if Runner.compile_program class_name p_str then Some class_name else None

module type Runner = sig
  val run_program : program -> command
end

module ProgramRunner (Cxt: Context) = struct

  (** [request] defines a set of all supported request types. *)
  type request = MyPosition | MilitaryUnit of Position.t | Tile of Position.t

  type input = Cmd of command | Req of request

  let strings_to_pos_coerce (s1, s2: string * string) : Position.t =
    match int_of_string_opt s1, int_of_string_opt s2 with
    | Some i1, Some i2 -> (i1, i2)
    | _ -> Cxt.get_my_pos

  let reader (i: in_channel) : input option =
    match String.split_on_char ' ' (input_line i) with
    | ["REQUEST"; "MY_POS"] -> Some (Req MyPosition)
    | ["REQUEST"; "MIL_UNIT"; p1; p2] ->
      Some (Req (MilitaryUnit (strings_to_pos_coerce (p1, p2))))
    | ["REQUEST"; "TILE"; p1; p2] ->
      Some (Req (Tile (strings_to_pos_coerce (p1, p2))))
    | ["COMMAND"; c] ->
      let cmd_opt = match c with
        | "DO_NOTHING" -> Some DoNothing
        | "ATTACK" -> Some Attack
        | "TRAIN" -> Some Train
        | "TURN_LEFT" -> Some TurnLeft
        | "TURN_RIGHT" -> Some TurnRight
        | "MOVE_FORWARD" -> Some MoveForward
        | "RETREAT_BACKWARD" -> Some RetreatBackward
        | "DIVIDE" -> Some Divide
        | "UPGRADE" -> Some Upgrade
        | _ -> None
      in
      begin
        match cmd_opt with
        | Some cmd -> Some (Cmd cmd)
        | None -> None
      end
    | _ -> None

  let writer (i: input) (o: out_channel) : unit =
    let s = match i with
      | Req MyPosition -> Position.to_string Cxt.get_my_pos
      | Req (MilitaryUnit p) ->
        p |> Cxt.get_mil_unit |>
        (function
          | Some m -> MilUnit.to_string m
          | None -> "NONE"
        )
      | Req (Tile p) -> p |> Cxt.get_tile |> Tile.to_string
      | Cmd _ -> failwith "Impossible Situation"
    in
    output_string o s;
    output_char o '\n';
    flush o

  let to_final_value : input -> command option = function
    | Cmd c -> Some c
    | Req _ -> None

  let rec run_program (program: program) : command =
    match Runner.get_value reader writer to_final_value program with
    | Some c -> c
    | None -> DoNothing
end
