open Common

(* Some type alias to improve readability of code. *)
type pos_2_id_map = int PosMap.t
type pos_2_tile_map = Tile.t PosMap.t
type id_2_pos_map = Position.t IntMap.t
type id_2_mil_unit_map = MilUnit.t IntMap.t

type t = {
  pos_2_id_map: pos_2_id_map;
  pos_2_tile_map: pos_2_tile_map;
  id_2_pos_map: id_2_pos_map;
  id_2_mil_unit_map: id_2_mil_unit_map;
}

(**
 * [rep_ok m] checks that the value [m]'s maps are all in sync.
 * i.e. Their records of military units and tiles agree with each other.
 * If so, [m] will be returned without modification.
 * Else, an exception will be thrown.
 *
 * Requires: None.
 * Returns: [m].
 * Raises: [Failure _] if [m] is not well-formed.
*)
let rep_ok (m: t) : t = m (* TODO check that all maps are in sync. *)

let init (m1: MilUnit.t) (m2: MilUnit.t) : t =
  if MilUnit.same_mil_unit m1 m2 then
    failwith "Cannot initialize the map with two same military units"
  else
    {
      (* TODO fix dummy implementation *)
      pos_2_id_map = PosMap.empty;
      pos_2_tile_map = PosMap.empty;
      id_2_pos_map = IntMap.empty;
      id_2_mil_unit_map = IntMap.empty;
    }

let get_position_opt_by_id (id: int) (m: t) : Position.t option =
  IntMap.find_opt id m.id_2_pos_map

let get_mil_unit_by_id (id: int) (m: t) : MilUnit.t =
  IntMap.find id m.id_2_mil_unit_map

let get_mil_unit_opt_by_id (id: int) (m: t) : MilUnit.t option =
  IntMap.find_opt id m.id_2_mil_unit_map

let get_mil_unit_opt_by_pos (pos: Position.t) (m: t) : MilUnit.t option =
  match PosMap.find_opt pos m.pos_2_id_map with
  | None -> None
  | Some id ->
    match get_mil_unit_opt_by_id id m with
    | None ->
      (* Guard against programmer error! *)
      failwith "ERROR! Data is not well synced!"
    | Some _ as v -> v

let get_tile_by_pos (pos: Position.t) (m: t) : Tile.t =
  match PosMap.find_opt pos m.pos_2_tile_map with
  | Some t -> t
  | None -> Tile.Mountain

let get_tile_opt_by_mil_id (id: int) (m: t) : Tile.t option =
  match get_position_opt_by_id id m with
  | None -> None
  | Some pos ->
    match PosMap.find_opt pos m.pos_2_tile_map with
    | None ->
      (* Guard against programmer error! *)
      failwith "ERROR! Data is not well synced!"
    | Some _ as v -> v

let update_mil_unit (id: int) (f: MilUnit.t -> MilUnit.t) (m: t) : t =
  match IntMap.find_opt id m.id_2_mil_unit_map with
  | None -> m
  | Some mil_unit ->
    let mil_unit' = f mil_unit in
    if MilUnit.same_mil_unit mil_unit mil_unit' then
      { m with id_2_mil_unit_map = IntMap.add id mil_unit' m.id_2_mil_unit_map }
    else
      failwith "Update operation cannot change the identity of a military unit.
      This is a programmer error."

let tile_map (m: t) : pos_2_tile_map = m.pos_2_tile_map
