open Definitions
open Common

type program = string

module type Context = sig
  val get_my_pos : Position.t
  val get_mil_unit : Position.t -> MilUnit.t option
  val get_tile : Position.t -> Tile.t
  val get_map : WorldMap.t
end

let from_string (i: player_identity) (p_str: string) : program option =
  let class_name = match i with
    | Black -> "BlackProgram"
    | White -> "WhiteProgram"
  in
  if Runner.compile_program class_name p_str then Some class_name else None

module ProgramRunner (Cxt: Context) = struct

  (** [request] defines a set of all supported request types. *)
  type request =
    | MyPosition | MilitaryUnit of Position.t | Tile of Position.t | Map

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
    | ["REQUEST"; "MAP"] -> Some (Req Map)
    | ["COMMAND"; cmd] -> Some (Cmd Attack)
    | _ -> None

  let writer (i: input) (o: out_channel) : unit =
    let s = match i with
      | Req MyPosition ->
        let (x, y) = Cxt.get_my_pos in
        string_of_int x ^ " " ^ string_of_int y
      | Req (MilitaryUnit p) ->
        begin match Cxt.get_mil_unit p with
          | Some m -> MilUnit.to_string m
          | None -> "NONE"
        end
      | Req (Tile p) ->
        let t = Cxt.get_tile p in
        Tile.to_string t
      | Req Map -> "MAP UNIMPLEMENTED"
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
