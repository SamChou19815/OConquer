open Definitions

module Position : Map.OrderedType = struct
  type t = int * int

  let compare ((p1x, p1y): t) ((p2x, p2y): t) : int =
    let c = compare p1x p2x in
    if c = 0 then compare p1y p2y else c
end

module Map = Map.Make (Position)

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

let exec (mil_unit: MilUnit.t) (action: command) (s: state) : state =
  match action with
  | Attack -> failwith "Bad!"
  | _ -> failwith "Bad!"

let next (s: state) : state = failwith "Bad!"

(* TODO getter methods *)

let get_mil_unit : int -> int -> state -> string = failwith ""

let get_game_info (s: state) : game_info = failwith ""
