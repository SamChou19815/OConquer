open Definitions
open Common

type state = {
  turns: int;
  world_map: WorldMap.t;
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
    execution_queue = [ 0; 1 ]; (* TODO fix dummy implementation *)
    black_program = p1;
    white_program = p2;
  }

let get_game_status (s: state) : game_status = InProgress

let get_map (s: state) : WorldMap.t = s.world_map

(**
 * [get_context id s] creates a specialized Context module that reports various
 * aspects of the map for a given state [s] and military unit id [id], which are
 * both infused into the context.
 *
 * Requires: [s] is a legal state and [id] refers to an existing id.
 * Returns: a context with the given state [s] infused in it.
*)
let get_context (id: int) (s: state) : (module Command.Context) =
  (* Some hack with first class module *)
  (module struct
    open Common
    open WorldMap

    let get_my_pos : Position.t =
      match get_position_opt_by_id id s.world_map with
      | Some p -> p
      | None -> failwith "Impossible Situation"

    let get_mil_unit (pos: Position.t) : MilUnit.t option =
      get_mil_unit_opt_by_pos pos s.world_map

    let get_tile (pos: Position.t) : Tile.t =
      get_tile_by_pos pos s.world_map
  end: Command.Context)

(**
 * [exec id action s] executes the action for the current military unit with
 * id [id] under state [s] to produce a new updated world map.
 *
 * Requires:
 * - [s] is a legal state.
 * - [id] refers to an existing id.
 * Returns: a new updated world map after the [action] has been done.
*)
let exec (id: int) (action: command) (s: state) : WorldMap.t =
  let update : (MilUnit.t -> MilUnit.t) -> WorldMap.t -> WorldMap.t =
    WorldMap.update_mil_unit id
  in
  let move_forward m : WorldMap.t = failwith "Unimplemented" in (* TODO *)
  match action with
  | DoNothing -> s.world_map
  | Attack -> failwith "Bad!"
  | Train -> update MilUnit.train s.world_map
  | TurnLeft -> update MilUnit.turn_left s.world_map
  | TurnRight -> update MilUnit.turn_right s.world_map
  | MoveForward -> move_forward s.world_map
  | RetreatBackward ->
    s.world_map
    |> update MilUnit.turn_right |> update MilUnit.turn_right (* turn back *)
    |> move_forward (* move forward is moving back since we turned back *)
    |> update MilUnit.apply_retreat_penalty (* retreat morale penalty *)
  | Divide -> failwith "Bad!"
  | Upgrade -> WorldMap.(
      match get_position_opt_by_id id s.world_map with
      | None -> failwith "Impossible Situation"
      | Some pos -> upgrade_tile pos s.world_map
    )

let next (s: state) : state =
  let rec next_helper (st: state) : int list -> state = function
    | [] -> st
    | mil_unit_id::tl ->
      let mil_unit = WorldMap.get_mil_unit_by_id mil_unit_id s.world_map in
      let program = match MilUnit.identity mil_unit with
        | Black -> s.black_program
        | White -> s.white_program
      in
      let open Command in
      (* Some hack with first class module *)
      let (module Cxt) = get_context mil_unit_id st in
      let (module R: Runner) = (module ProgramRunner (Cxt)) in
      let cmd = R.run_program program in
      let world_map' = exec mil_unit_id cmd s in
      (* TODO check whether the military unit is in a city and increase its
       * number of soldiers accordingly. *)
      let s' = {
        s with
        turns = s.turns + 1; world_map = world_map';
      } in
      next_helper s' tl
  in
  next_helper s s.execution_queue
