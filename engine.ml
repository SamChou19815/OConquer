open Definitions
open Common

type state = {
  turns: int;
  world_map: WorldMap.t;
  current_mil_unit: int;
  execution_queue: int list;
  black_program: Command.program;
  white_program: Command.program;
}

let init (p1: Command.program) (p2: Command.program) : state =
  let m1 = MilUnit.default_init Black 0 0 in
  let m2 = MilUnit.default_init White 1 3 in
  {
    turns = 0;
    world_map = WorldMap.init m1 m2;
    current_mil_unit = 0;
    execution_queue = [ 0; 1 ]; (* TODO fix dummy implementation *)
    black_program = p1;
    white_program = p2;
  }

let get_mil_unit (pos: Position.t) (s: state) : MilUnit.t option =
  s.world_map |> WorldMap.mil_unit_map |> PosMap.find_opt pos

let get_tile (pos: Position.t) (s: state) : Tile.t =
  match s.world_map |> WorldMap.tile_map |> PosMap.find_opt pos with
  | Some t -> t
  | None -> Tile.Mountain

let get_position (mil_unit: MilUnit.t) (s: state) : Position.t option =
  failwith "Unimplemented"

let get_game_status (s: state) : game_status = InProgress

let get_map (s: state) : WorldMap.t = s.world_map

(**
 * [get_context s] creates a specialized Context module that reports various
 * aspects of the map for a given state [s], which is infused into the context.
 *
 * Requires: [s] is a legal state.
 * Returns: a context with the given state [s] infused in it.
*)
let get_context (s: state) : (module Command.Context) =
  (* Some hack with first class module *)
  (module struct
    open Common

    let get_my_pos : Position.t =
      let mil_unit = WorldMap.get_mil_unit s.current_mil_unit s.world_map in
      match get_position mil_unit s with
      | Some p -> p
      | None -> failwith "Impossible Situation"

    let get_mil_unit (pos: Position.t) : MilUnit.t option =
      get_mil_unit pos s

    let get_tile (pos: Position.t) : Tile.t =
      get_tile pos s

    let get_map : WorldMap.t = get_map s
  end: Command.Context)

(**
 * [exec action s] executes the action for the current military unit in
 * state [s] to produce a new updated world map.
 *
 * Requires: [s] is a legal state.
 * Returns: a new updated world map after the [action] has been done.
*)
let exec (action: command) (s: state) : WorldMap.t =
  let turn_right m =
    WorldMap.update_mil_unit MilUnit.turn_right s.current_mil_unit m
  in
  let move_forward m = failwith "Unimplemented" in (* TODO move forward *)
  match action with
  | DoNothing -> s.world_map
  | Attack -> failwith "Bad!"
  | Train ->
    WorldMap.update_mil_unit MilUnit.train s.current_mil_unit s.world_map
  | TurnLeft ->
    WorldMap.update_mil_unit MilUnit.turn_left s.current_mil_unit s.world_map
  | TurnRight ->
    WorldMap.update_mil_unit MilUnit.turn_right s.current_mil_unit s.world_map
  | MoveForward -> move_forward s.world_map
  | RetreatBackward ->
    let reduce_morale m =
      (* TODO fix numeric value *)
      WorldMap.update_mil_unit (MilUnit.reduce_morale_by 1) s.current_mil_unit m
    in
    s.world_map |> turn_right |> turn_right |> move_forward |> reduce_morale
  | Divide -> failwith "Bad!"
  | Upgrade -> failwith "Bad!"

let next (s: state) : state =
  let rec next_helper (st: state) : int list -> state = function
    | [] -> st
    | mil_unit_id::tl ->
      let mil_unit = WorldMap.get_mil_unit mil_unit_id s.world_map in
      let program = match MilUnit.identity mil_unit with
        | Black -> s.black_program
        | White -> s.white_program
      in
      let open Command in
      (* Some hack with first class module *)
      let (module Cxt) = get_context st in
      let (module R: Runner) = (module ProgramRunner (Cxt)) in
      let cmd = R.run_program program in
      let world_map' = exec cmd s in
      (* TODO check whether the military unit is in a city and increase its
       * number of soldiers accordingly. *)
      let s' = {
        s with
        turns = s.turns + 1; world_map = world_map';
        current_mil_unit = s.current_mil_unit (* TODO fix this *)
      } in
      next_helper s' tl
  in
  next_helper s s.execution_queue
