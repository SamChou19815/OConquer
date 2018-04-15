open Common

(* Some type alias to improve readability of code. *)
type pos_2_id_map = int PosMap.t
type pos_2_tile_map = Tile.t PosMap.t
type id_2_pos_map = Position.t IntMap.t
type id_2_mil_unit_map = MilUnit.t IntMap.t

type maps = {
  (* Bind id to military unit, allowing quick update on a military unit. *)
  id_2_mil_unit_map: id_2_mil_unit_map;
  (* Following two form a bidirectional map of id <-> position, allowing a quick
   * update and query from both direction. *)
  id_2_pos_map: id_2_pos_map;
  pos_2_id_map: pos_2_id_map;
  (* Bind tile to a position. Used for tile querying and updating alone. It is
   * completely separate from the above three maps. *)
  pos_2_tile_map: pos_2_tile_map;
}

type t = {
  maps: maps;
  execution_queue: int Queue.t
}

exception IllegalWorldMapOperation of string

(**
 * [DataNotSyncedException] is used internally to indicate that data is not
 * well synced between different maps.
*)
exception DataNotSyncedException

(**
 * [rep_ok m] checks that the value [m]'s maps are all in sync.
 * i.e. Their records of military units and tiles agree with each other.
 * If so, [m] will be returned without modification.
 * Else, an exception will be thrown.
 *
 * Requires: None.
 * Returns: [m].
 * Raises: [DataNotSyncedException] if [m] is not well-formed.
*)
let rep_ok (m: t) : t = m (* TODO check that all maps are in sync. *)

(**
 * [illegal_ops error_msg] raises an [IllegalWorldMapOperation] with error
 * message [error_msg].
 *
 * Requires: None.
 * Returns: None.
 * Raises: [IllegalWorldMapOperation error_msg].
*)
let illegal_ops (error_msg: string) : 'a =
  raise (IllegalWorldMapOperation error_msg)

let init (m1: MilUnit.t) (m2: MilUnit.t) : t =
  if MilUnit.same_mil_unit m1 m2 then
    illegal_ops "Cannot initialize the map with two same military units"
  else
    {
      maps = {
        (* TODO fix dummy implementation *)
        id_2_mil_unit_map = IntMap.empty;
        id_2_pos_map = IntMap.empty;
        pos_2_id_map = PosMap.empty;
        pos_2_tile_map = PosMap.empty;
      };
      execution_queue = Queue.create () (* TODO fix dummy implementation *)
    }

let get_position_opt_by_id (id: int) (m: t) : Position.t option =
  IntMap.find_opt id m.maps.id_2_pos_map

let get_mil_unit_by_id (id: int) (m: t) : MilUnit.t =
  IntMap.find id m.maps.id_2_mil_unit_map

let get_mil_unit_opt_by_id (id: int) (m: t) : MilUnit.t option =
  IntMap.find_opt id m.maps.id_2_mil_unit_map

let get_mil_unit_opt_by_pos (pos: Position.t) (m: t) : MilUnit.t option =
  match PosMap.find_opt pos m.maps.pos_2_id_map with
  | None -> None
  | Some id ->
    match get_mil_unit_opt_by_id id m with
    | None -> raise DataNotSyncedException (* Guard against programmer error! *)
    | Some _ as v -> v

let get_tile_by_pos (pos: Position.t) (m: t) : Tile.t =
  match PosMap.find_opt pos m.maps.pos_2_tile_map with
  | Some t -> t
  | None -> Tile.Mountain

let get_tile_opt_by_mil_id (id: int) (m: t) : Tile.t option =
  match get_position_opt_by_id id m with
  | None -> None
  | Some pos ->
    match PosMap.find_opt pos m.maps.pos_2_tile_map with
    | None -> raise DataNotSyncedException (* Guard against programmer error! *)
    | Some _ as v -> v

let get_tile_by_mil_id (id: int) (m: t) : Tile.t =
  match get_position_opt_by_id id m with
  | None -> raise Not_found
  | Some pos ->
    match PosMap.find_opt pos m.maps.pos_2_tile_map with
    | None -> raise DataNotSyncedException (* Guard against programmer error! *)
    | Some t -> t

let update_mil_unit (id: int) (f: MilUnit.t -> MilUnit.t) (m: t) : t =
  match IntMap.find_opt id m.maps.id_2_mil_unit_map with
  | None -> m
  | Some mil_unit ->
    let mil_unit' = f mil_unit in
    if MilUnit.same_mil_unit mil_unit mil_unit' then
      { m with
        maps = {
          m.maps with
          id_2_mil_unit_map = IntMap.add id mil_unit' m.maps.id_2_mil_unit_map
        }
      }
    else
      illegal_ops ("Update operation cannot change the identity"
                   ^ "of a military unit. This is a programmer error.")

let upgrade_tile (pos: Position.t) (m: t) : t =
  let tile = get_tile_by_pos pos m in
  let tile' = Tile.upgrade_tile tile in
  { m with
    maps = { m.maps with
             pos_2_tile_map = PosMap.add pos tile' m.maps.pos_2_tile_map
           }
  }

(**
 * [put_mil_unit pos mil_unit] puts a military unit [mil_unit] at position
 * [pos]. The given position must contain no other military unit, and the tile
 * must not be [Mountain].
 *
 * Requires:
 * - There is no other military unit at [pos].
 * - Tile at [pos] should not be mountain.
 * - [m] is a legal world map.
 * Returns: the updated map with the given [mil_unit] put at [pos].
 * Raises:
 * - [IllegalWorldMapOperation "Occupied"] if the [pos] is already occupied by
 *   other military unit.
 * - [IllegalWorldMapOperation "Put on mountain"] if the tile on [pos] is a
 *   mountain.
*)
let put_mil_unit (pos: Position.t) (mil_unit: MilUnit.t) (m: t) : t =
  (* Check whether it's occupied. *)
  match get_mil_unit_opt_by_pos pos m with
  | Some _ -> illegal_ops "Occupied"
  | None ->
    match get_tile_by_pos pos m with
    (* It can guard out-of-bound position
     * because they are all mapped to mountain. *)
    | Mountain -> illegal_ops "Put on mountain"
    | _ ->
      let id = MilUnit.id mil_unit in
      { m with
        maps = {
          m.maps with
          (* Add to map if it does not exist previously *)
          id_2_mil_unit_map = IntMap.add id mil_unit m.maps.id_2_mil_unit_map;
          (* Update position of that military unit. *)
          id_2_pos_map = IntMap.add id pos m.maps.id_2_pos_map;
          (* Update the content at that position. *)
          pos_2_id_map = PosMap.add pos id m.maps.pos_2_id_map;
        }
      }

(**
 * [remove_mil_unit pos] removes the military unit at [pos] if there is one.
 *
 * Requires:
 * - [pos] can be any position.
 * - [m] is a legal world map.
 * Returns: the updated map with some military unit removed at [pos].
*)
let remove_mil_unit (pos: Position.t) (m: t) : t =
  match PosMap.find_opt pos m.maps.pos_2_id_map with
  | None -> m
  | Some id ->
    { m with
      maps = {
        m.maps with
        (* Remove from id -> mil unit binding *)
        id_2_mil_unit_map = IntMap.remove id m.maps.id_2_mil_unit_map;
        (* Remove position of that military unit. *)
        id_2_pos_map = IntMap.remove id m.maps.id_2_pos_map;
        (* Remove the content at that position. *)
        pos_2_id_map = PosMap.remove pos m.maps.pos_2_id_map;
      }
    }

let next (process_mil_unit: int -> t -> t) (m: t) : t =
  (* To store all the military units' id that can possibly exist. *)
  let temp_queue : int Queue.t = Queue.create () in
  (* Iterate through the execution list to execute according to
   * [process_mil_unit] *)
  let rec next_process (map: t) : t =
    if Queue.is_empty map.execution_queue then map
    else
      let id = Queue.pop map.execution_queue in
      (* First check whether the id still exist. *)
      if IntMap.mem id m.maps.id_2_mil_unit_map then
        (* Only executed military unit may exist at a later time. *)
        let () = Queue.push id temp_queue in
        let map' = process_mil_unit id map in
        next_process map'
      else next_process map
  in
  (* Add back alive military units. *)
  let end_of_turn_process (map: t) : t =
    while Queue.is_empty temp_queue do
      let id = Queue.pop temp_queue in
      if IntMap.mem id m.maps.id_2_mil_unit_map then
        (* Only add back if it still exists *)
        Queue.push id map.execution_queue
    done;
    map
  in
  m |> next_process |> end_of_turn_process
