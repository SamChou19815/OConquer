open Definitions
open Common

module Map = Map.Make (Position)

type state = {
  turns: int;
  world_map: WorldMap.t;
  execution_queue: MilUnit.t list;
}

let init (p1: Command.program) (p2: Command.program) : state =
  let m1 = MilUnit.default_init 0 0 in
  let m2 = MilUnit.default_init 1 3 in
  {
    turns = 0;
    world_map = WorldMap.init m1 m2;
    execution_queue = [ m1; m2 ];
  }

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

let next (s: state) : state = failwith "Bad!"

let get_mil_unit (pos: Position.t) (s: state) : MilUnit.t option =
  Map.find_opt pos s.world_map.mil_unit_map

let get_tile (pos: Position.t) (s: state) : Tile.t option =
  Map.find_opt pos s.world_map.tile_map

let get_position (mil_unit: MilUnit.t) (s: state) : Position.t option =
  failwith "Unimplemented"

let get_game_status (s: state) : game_status = InProgress

let get_map (s: state) : WorldMap.t = s.world_map
