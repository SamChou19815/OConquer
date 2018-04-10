open Common

(* Some type alias to improve readability of code. *)
type pos_2_id_map = int PosMap.t
type pos_2_tile_map = Tile.t PosMap.t
type id_2_mil_unit_map = MilUnit.t IntMap.t

type t = {
  pos_2_id_map: pos_2_id_map;
  pos_2_tile_map: pos_2_tile_map;
  id_2_mil_unit_map: id_2_mil_unit_map;
}

let init (m1: MilUnit.t) (m2: MilUnit.t) : t =
  if MilUnit.same_mil_unit m1 m2 then
    failwith "Cannot initialize the map with two same military units"
  else
    {
      (* TODO fix dummy implementation *)
      pos_2_id_map = PosMap.empty;
      pos_2_tile_map = PosMap.empty;
      id_2_mil_unit_map = IntMap.empty;
    }

let get_mil_unit_opt (id: int) (m: t) : MilUnit.t option =
  IntMap.find_opt id m.id_2_mil_unit_map

let get_mil_unit (id: int) (m: t) : MilUnit.t =
  IntMap.find id m.id_2_mil_unit_map

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

let mil_unit_map (m: t) : MilUnit.t PosMap.t = failwith "Unimplemented"

let tile_map (m: t) : pos_2_tile_map = m.pos_2_tile_map
