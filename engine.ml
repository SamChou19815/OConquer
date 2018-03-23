module Map = Map.Make (String) (* String should actually be a position tuple. *)

type state = {
  turns: int;
  game_map: MilUnit.t Map.t;
  execution_queue: MilUnit.t list;
}

type game_info = {
  info: string;
}

let init (p1: Command.program) (p2: Command.program) : state = {
  turns = 0;
  game_map = Map.empty; (* TODO not empty *)
  execution_queue = [];
}

let exec (mil_unit: MilUnit.t) (action: Command.t) (s: state) : state =
  match action with
  | Attack -> failwith "Bad!"
  | _ -> failwith "Bad!"

let run (s: state) : state = failwith "Bad!"

(* TODO getter methods *)

let get_mil_unit : int -> int -> state -> string = failwith ""

let get_game_info (s: state) : game_info = failwith ""
