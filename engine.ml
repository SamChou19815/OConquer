open Definitions
open Common

type state = {
  turns: int;
  world_map: WorldMap.t;
  black_program: Command.program;
  white_program: Command.program;
}

let init (p1: Command.program) (p2: Command.program) : state =
  let m1 = MilUnit.default_init Black 0 0 in
  let m2 = MilUnit.default_init White 1 3 in
  {
    turns = 0;
    world_map = WorldMap.init m1 m2;
    black_program = p1;
    white_program = p2;
  }

let get_game_status (s: state) : game_status = InProgress

let get_map (s: state) : WorldMap.t = s.world_map

(**
 * [get_context id m] creates a specialized Context module that reports various
 * aspects of the map for a given map [m] and military unit id [id], which are
 * both infused into the context.
 *
 * Requires: [m] is a legal world map and [id] refers to an existing id.
 * Returns: a context with the given state [s] infused in it.
*)
let get_context (id: int) (m: WorldMap.t) : (module Command.Context) =
  (* Some hack with first class module *)
  (module struct
    open WorldMap

    let get_my_pos : Position.t =
      match get_position_opt_by_id id m with
      | Some p -> p
      | None -> failwith "Impossible Situation"

    let get_mil_unit (pos: Position.t) : MilUnit.t option =
      get_mil_unit_opt_by_pos pos m

    let get_tile (pos: Position.t) : Tile.t =
      get_tile_by_pos pos m
  end: Command.Context)

(**
 * [exec id action m] executes the action for the current military unit with
 * id [id] under world map [m] to produce a new updated world map.
 *
 * Requires:
 * - [m] is a legal world map.
 * - [id] refers to an existing id.
 * Returns: a new updated world map after the [action] has been done.
*)
let exec (id: int) (action: command) (m: WorldMap.t) : WorldMap.t =
  let update : (MilUnit.t -> MilUnit.t) -> WorldMap.t -> WorldMap.t =
    WorldMap.update_mil_unit id
  in
  let move_forward m : WorldMap.t = failwith "Unimplemented" in (* TODO *)
  match action with
  | DoNothing -> m
  | Attack -> failwith "Bad!"
  | Train -> update MilUnit.train m
  | TurnLeft -> update MilUnit.turn_left m
  | TurnRight -> update MilUnit.turn_right m
  | MoveForward -> move_forward m
  | RetreatBackward ->
    m
    |> update MilUnit.turn_right |> update MilUnit.turn_right (* turn back *)
    |> move_forward (* move forward is moving back since we turned back *)
    |> update MilUnit.apply_retreat_penalty (* retreat morale penalty *)
  | Divide -> failwith "Bad!"
  | Upgrade -> WorldMap.(
      match get_position_opt_by_id id m with
      | None -> failwith "Impossible Situation"
      | Some pos -> upgrade_tile pos m
    )

(**
 * [get_program s mil_unit] obtains the program of a military unit [mil_unit]
 * under state [s].
 *
 * Requires:
 * - [s] is a legal state.
 * - [m] is a legal military unit.
 * Returns: the program of the given military unit.
*)
let get_program (s: state) (mil_unit: MilUnit.t) : Command.program =
  match MilUnit.identity mil_unit with
  | Black -> s.black_program
  | White -> s.white_program

(**
 * [process_mil_unit get_program mil_unit_id map] uses [get_program] function
 * to obtain the military unit's program, execute it under given [map] to
 * produce a new map.
 *
 * Requires:
 * - [get_program] can return the program of the military unit.
 * - [mil_unit_id] refers to an existing id of the military unit.
 * - [map] is a legal world map.
 * Returns: the updated world map after processing the given military unit.
*)
let process_mil_unit (get_program: MilUnit.t -> Command.program)
    (mil_unit_id: int) (map: WorldMap.t) : WorldMap.t =
  let m_init = WorldMap.get_mil_unit_by_id mil_unit_id map in
  (* Step 1: Increase number of soldiers accordingly. *)
  let tile_of_unit = WorldMap.get_tile_by_mil_id mil_unit_id map in
  let num_soldier_increase = Tile.num_of_soldier_increase tile_of_unit in
  let mil_unit = MilUnit.increase_soldier_by num_soldier_increase m_init in
  (* Step 2: Run the program *)
  let program = get_program mil_unit in
  let open Command in
  (* Some hack with first class module *)
  let (module Cxt) = get_context mil_unit_id map in
  let (module R: Runner) = (module ProgramRunner (Cxt)) in
  let cmd = R.run_program program in
  exec mil_unit_id cmd map

let next (s: state) : state =
  let world_map' = WorldMap.next (process_mil_unit (get_program s)) s.world_map in
  { s with turns = s.turns + 1; world_map = world_map' }
