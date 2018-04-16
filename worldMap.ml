open Common

(* Some type alias to improve readability of code. *)
type pos_2_id_map = int PosMap.t
type pos_2_tile_map = Tile.t PosMap.t
type id_2_pos_map = Position.t IntMap.t
type id_2_mil_unit_map = MilUnit.t IntMap.t

(** [maps] contains a collection of all the maps. *)
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
  next_id: int; (* Next ID that can be used by a military unit. *)
  changed_pos: Position.t HashSet.t; (* A set of changed position in a round. *)
  execution_queue: int Queue.t; (* A queue of military unit id. *)
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
    let execution_queue = Queue.create () in
    let () = Queue.(add 0 execution_queue; add 1 execution_queue) in
    {
      maps = {
        (* TODO fix dummy implementation *)
        id_2_mil_unit_map = IntMap.empty;
        id_2_pos_map = IntMap.empty;
        pos_2_id_map = PosMap.empty;
        pos_2_tile_map = PosMap.empty; (* TODO Fill tiles *)
      };
      next_id = 2;
      changed_pos = HashSet.create ();
      execution_queue;
    }

let get_position_by_id (id: int) (m: t) : Position.t =
  IntMap.find id m.maps.id_2_pos_map

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
  let pos = get_position_by_id id m in
  match PosMap.find_opt pos m.maps.pos_2_tile_map with
  | None -> raise DataNotSyncedException (* Guard against programmer error! *)
  | Some t -> t

(**
 * [get_pos_ahead direction pos] returns a position directly ahead of the
 * given [pos] pointing to direction [direction].
 *
 * Requires:
 * - [direction] is 0, 1, 2, 3, representing east, north, west, south.
 * - [pos] can be any position.
 * Returns: [p'] such that [p'] is ahead of [pos] according to [direction].
*)
let get_pos_ahead (dir: int) (x, y: Position.t) : Position.t =
  match dir with
  | 0 -> (x + 1, y)
  | 1 -> (x, y + 1)
  | 2 -> (x - 1, y)
  | 3 -> (x, y - 1)
  | _ -> failwith "Bad Direction! Data Corrupted!"

let get_passable_pos_ahead (d: int) (p: Position.t) (m: t) : Position.t option =
  let new_pos = get_pos_ahead d p in
  match get_tile_by_pos new_pos m with
  | Mountain -> None (* Cannot move to mountain! *)
  | _ ->
    match PosMap.find_opt new_pos m.maps.pos_2_id_map with
    | Some _ -> None (* Cannot move onto another military unit! *)
    | None -> Some new_pos (* OK to move! *)

let update_mil_unit (id: int) (f: MilUnit.t -> MilUnit.t) (m: t) : t =
  match IntMap.find_opt id m.maps.id_2_mil_unit_map with
  | None -> m
  | Some mil_unit ->
    let mil_unit' = f mil_unit in
    if MilUnit.same_mil_unit mil_unit mil_unit' then
      (** Report change in position of the military unit. *)
      let () = HashSet.add (get_position_by_id id m) m.changed_pos in
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
  (** Report change in position of the military unit. *)
  let () = HashSet.add pos m.changed_pos in
  { m with
    maps =
      { m.maps with
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
      (** Report change in position of the military unit. *)
      let () = HashSet.add pos m.changed_pos in
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
    (** Report change in position of the military unit. *)
    let () = HashSet.add pos m.changed_pos in
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

let move_mil_unit_forward (id: int) (m: t) : t =
  match IntMap.find_opt id m.maps.id_2_mil_unit_map with
  | None -> m
  | Some mil_unit ->
    let direction = MilUnit.direction mil_unit in
    let old_pos = get_position_by_id id m in
    match get_passable_pos_ahead direction old_pos m with
    | None -> m (* Cannot move, do nothing/change nothing. *)
    | Some new_pos -> (* OK to move now! *)
      m |> remove_mil_unit old_pos |> put_mil_unit new_pos mil_unit

let attack (id: int) (m: t) : t =
  match IntMap.find_opt id m.maps.id_2_mil_unit_map with
  | None -> m
  | Some mil_unit1 ->
    let direction = MilUnit.direction mil_unit1 in
    let my_pos = get_position_by_id id m in
    let ahead_pos = get_pos_ahead direction my_pos in
    match get_mil_unit_opt_by_pos ahead_pos m with
    | None -> m (* Nothing to attack *)
    | Some mil_unit2 ->
      (* DO NOT attack the soldiers from the same side *)
      if MilUnit.(identity mil_unit1 = identity mil_unit2) then m
      else
        let id2 = MilUnit.id mil_unit2 in
        let tile_pair =
          match get_tile_opt_by_mil_id id m, get_tile_opt_by_mil_id id2 m with
          | Some t1, Some t2 -> (t1, t2)
          | _ -> raise DataNotSyncedException
        in
        (* Do operations according to attack result.
         * We first remove all of them, then add back those that are still
         * alive. *)
        let map' = m |> remove_mil_unit my_pos |> remove_mil_unit ahead_pos in
        match MilUnit.attack tile_pair (mil_unit1, mil_unit2) with
        | Some m1, Some m2 ->
          map' |> put_mil_unit my_pos m1 |> put_mil_unit ahead_pos m2
        | Some m1, None -> put_mil_unit my_pos m1 map'
        | None, Some m2 -> put_mil_unit ahead_pos m2 map'
        | None, None -> map'

let divide (id: int) (m: t) : t =
  match IntMap.find_opt id m.maps.id_2_mil_unit_map with
  | None -> m
  | Some mil_unit ->
    let direction = MilUnit.direction mil_unit in
    let my_pos = get_position_by_id id m in
    match get_passable_pos_ahead direction my_pos m with
    | None -> m (* No place to divide *)
    | Some ahead_pos ->
      match MilUnit.divide mil_unit with
      | None -> m (* Impossible to divide *)
      | Some (m1, m2) ->
        let () = Queue.add (MilUnit.id m2) m.execution_queue in
        let m' = { m with next_id = m.next_id + 1 } in
        m' |> put_mil_unit my_pos m1 |> put_mil_unit ahead_pos m2

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
    while temp_queue |> Queue.is_empty |> not do
      let id = Queue.pop temp_queue in
      if IntMap.mem id m.maps.id_2_mil_unit_map then
        (* Only add back if it still exists *)
        Queue.push id map.execution_queue
    done;
    HashSet.clear map.changed_pos;
    map
  in
  m |> next_process |> end_of_turn_process
