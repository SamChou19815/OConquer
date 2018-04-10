open Definitions
open Common

type state = {
  turns: int;
  world_map: WorldMap.t;
  current_mil_unit: MilUnit.t;
  execution_queue: MilUnit.t list;
  black_program: Command.program;
  white_program: Command.program;
}

let init (p1: Command.program) (p2: Command.program) : state =
  let m1 = MilUnit.default_init Black 0 0 in
  let m2 = MilUnit.default_init White 1 3 in
  {
    turns = 0;
    world_map = WorldMap.init m1 m2;
    current_mil_unit = m1;
    execution_queue = [ m1; m2 ];
    black_program = p1;
    white_program = p2;
  }

let get_mil_unit (pos: Position.t) (s: state) : MilUnit.t option =
  PosMap.find_opt pos s.world_map.mil_unit_map

let get_tile (pos: Position.t) (s: state) : Tile.t =
  match PosMap.find_opt pos s.world_map.tile_map with
  | Some t -> t
  | None -> Tile.Mountain

let get_position (mil_unit: MilUnit.t) (s: state) : Position.t option =
  failwith "Unimplemented"

let get_game_status (s: state) : game_status = InProgress

let get_map (s: state) : WorldMap.t = s.world_map

let get_context (s: state) : (module Command.Context) =
  (* Some hack with first class module *)
  (module struct
    open Common

    let get_my_pos : Position.t =
      match get_position s.current_mil_unit s with
      | Some p -> p
      | None -> failwith "Impossible Situation"

    let get_mil_unit (pos: Position.t) : MilUnit.t option =
      get_mil_unit pos s

    let get_tile (pos: Position.t) : Tile.t =
      get_tile pos s

    let get_map : WorldMap.t = get_map s
  end: Command.Context)

let exec (mil_unit: MilUnit.t) (action: command) (s: state) : state =
  match action with
  | DoNothing -> failwith "Bad!"
  | Attack -> failwith "Bad!"
  | Train -> failwith "Bad!"
  | TurnLeft -> failwith "Bad!"
  | TurnRight -> failwith "Bad!"
  | MoveForward -> failwith "Bad!"
  | RetreatBackward -> failwith "Bad!"
  | Divide -> failwith "Bad!"
  | Upgrade -> failwith "Bad!"

let next (s: state) : state =
  let rec next_helper (st: state) : MilUnit.t list -> state = function
    | [] -> st
    | mil_unit::tl ->
      let program = match MilUnit.identity mil_unit with
        | Black -> s.black_program
        | White -> s.white_program
      in
      let open Command in
      (* Some hack with first class module *)
      let (module Cxt) = get_context st in
      let (module R: Runner) = (module ProgramRunner (Cxt)) in
      let cmd = R.run_program program in
      let s' = exec mil_unit cmd s in
      next_helper s' tl
  in
  next_helper s s.execution_queue
