open Definitions
open Common

type program = {
  handle: Runner.running_program;
  player: player_identity;
}

module type Context = sig
  val get_my_pos : Position.t
  val get_mil_unit : Position.t -> MilUnit.t option
  val get_tile : Position.t -> Tile.t
end

let from_string (b: string) (w: string) : (program * program) option =
  match Runner.start_program b w with
  | None -> None
  | Some handle -> Some (
      { handle; player = Black },
      { handle; player = White }
    )

let stop_program (p, _: program * program) : unit = Runner.stop_program p.handle

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

  let reader (line: string) : input =
    match String.split_on_char ' ' line with
    | ["REQUEST"; "MY_POS"] -> Req MyPosition
    | ["REQUEST"; "MIL_UNIT"; p1; p2] ->
      Req (MilitaryUnit (strings_to_pos_coerce (p1, p2)))
    | ["REQUEST"; "TILE"; p1; p2] ->
      Req (Tile (strings_to_pos_coerce (p1, p2)))
    | ["COMMAND"; c] ->
      let cmd = match c with
        | "DO_NOTHING" -> DoNothing
        | "ATTACK" -> Attack
        | "TRAIN" -> Train
        | "TURN_LEFT" -> TurnLeft
        | "TURN_RIGHT" -> TurnRight
        | "MOVE_FORWARD" -> MoveForward
        | "RETREAT_BACKWARD" -> RetreatBackward
        | "DIVIDE" -> Divide
        | "UPGRADE" -> Upgrade
        | _ -> failwith ("Wrong Action! Your action is: " ^ c)
      in
      Cmd cmd
    | _ -> failwith ("Wrong Command! Your command is: " ^ line)

  let writer (i: input) : string =
    match i with
    | Req MyPosition -> Position.to_string Cxt.get_my_pos
    | Req (MilitaryUnit p) ->
      p |> Cxt.get_mil_unit |>
      (function
        | Some m -> MilUnit.to_string m
        | None -> "NONE"
      )
    | Req (Tile p) -> p |> Cxt.get_tile |> Tile.to_string
    | Cmd _ -> failwith "Impossible Situation"

  let to_final_value : input -> command option = function
    | Cmd c -> Some c
    | Req _ -> None

  let rec run_program (p: program) : command =
    match Runner.get_value reader writer to_final_value p.player p.handle with
    | Some c -> c
    | None -> DoNothing
end
