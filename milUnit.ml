open Definitions
open GameConstants

type t = {
  identity: player_identity;
  id: int;
  direction: int; (* 0 -> east, 1 -> north, 2 -> west, 3 -> south *)
  num_soliders: int;
  morale: int;
  leadership: int;
}

let init (identity: player_identity) (id: int) (direction: int)
    (num_soliders: int) (morale: int) (leadership: int) =
  { identity; id; direction; num_soliders; morale; leadership }

let default_init (identity: player_identity) (id: int) (direction: int) =
  init identity id direction 10000 1 1

let same_mil_unit (m1: t) (m2: t) : bool =
  m1.identity = m2.identity && m1.id = m2.id

let identity (m: t) : player_identity = m.identity

let id (m: t) : int = m.id

let direction (m: t) : int = m.direction

let num_soliders (m: t) : int = m.num_soliders

let morale (m: t) : int = m.morale

let leadership (m: t) : int = m.leadership

let increase_soldier_by (n: int) (m: t) : t =
  if n < 0 then failwith "Bad Input n!"
  else if n = 0 then m
  else { m with num_soliders = m.num_soliders + n }

(**
 * [turn right m] lets the military unit [m] turn right or left depending on
 * whether [right] is true.
 *
 * Requires: [m] is a legal military unit.
 * Returns: the result of turning for that military unit.
*)
let turn (right: bool) (m: t) : t =
  let offset = if right then 1 else -1 in
  let direction' = (m.direction + offset + 4) mod 4 in
  { m with direction = direction' }

let turn_left : t -> t = turn false

let turn_right : t -> t = turn true

let train (m: t) : t =
  { m with
    morale = m.morale + training_morale_boost;
    leadership = m.leadership + training_leadership_boost
  }

(**
 * [reduce_morale_by a m] reduces the morale of the military unit [m] by [a].
 * If the resultant morale is negative, it will be reset to 0.
 * If [a] is not-positive, it has no effect.
 *
 * Requires: [m] is a legal military unit.
 * Returns: the result of reducing the morale of the military unit.
*)
let reduce_morale_by (amount: int) (m: t) : t =
  if amount > 0 then
    let morale = m.morale - amount in
    let morale_normalized = if morale < 0 then 0 else morale in
    { m with morale = morale_normalized }
  else m

(**
 * [reduce_leadership_by a m] reduces the leadership of the military unit [m]
 * by [a].
 * If the resultant leadership is negative, it will be reset to 0.
 * If [a] is not-positive, it has no effect.
 *
 * Requires: [m] is a legal military unit.
 * Returns: the result of reducing the morale of the military unit.
*)
let reduce_leadership_by (amount: int) (m: t) : t =
  if amount > 0 then
    let leadership = m.leadership - amount in
    let leadership_normalized = if leadership < 0 then 0 else leadership in
    { m with leadership = leadership_normalized }
  else m

let apply_retreat_penalty (m: t) : t =
  m |> reduce_morale_by retreat_morale_penalty
  |> reduce_leadership_by retreat_leadership_penalty


let attack_damage (leadership: int) (morale: int) : int =
  let base_damage = base_attack_damage in
  if leadership >0 && morale >0
  then leadership * morale * base_damage
  else base_damage



let attack (t1, t2: Tile.t * Tile.t) (m1, m2: t * t) : (t option * t option) =
  if same_mil_unit m1 m2 then (Some m1, Some m2)
  else
    (* Initializing attack actively grants more winning possibility in addition
       to other attributes*)
    let attacker_bonus = 1 + Random.int 1 in
    let m1_damage = (attack_damage m1.leadership m1.morale) * attacker_bonus in
    let m2_damage = attack_damage m2.leadership m2.morale in
    let m1_num_soliders =
    if t1 = Fort then m1.num_soliders - m2_damage/fort_bonus_factor
    else m1.num_soliders - m2_damage in
    let m1_num_soliders_normalized =
      if m1_num_soliders < 0 then 0 else m1_num_soliders in
      let m2_num_soliders =
      if t2 = Fort then m2.num_soliders - m1_damage/fort_bonus_factor
      else m2.num_soliders - m1_damage in
      let m2_num_soliders_normalized =
      if m2_num_soliders < 0 then 0 else m2_num_soliders  in
    match m1_num_soliders_normalized, m2_num_soliders_normalized with
    | 0, 0 -> (None, None)
    | 0, _ -> (None, Some {m2 with num_soliders = m2_num_soliders_normalized})
    | _, 0 -> (Some {m1 with num_soliders = m1_num_soliders_normalized }, None)
    | _, _ -> (Some {m1 with num_soliders = m1_num_soliders_normalized },
               Some {m2 with num_soliders = m2_num_soliders_normalized})


let divide (m: t) (next_id: int): (t * t) option =
  if m.num_soliders <= 1 then None
  else
    let even_split = m.num_soliders mod 2 in
    let m1 = { m with num_soliders = m.num_soliders/2 } in
    let m2 = { m with id = next_id;
               num_soliders = if even_split = 0
               then m.num_soliders/2 else 1+ m.num_soliders/2; } in
    Some (m1, m2)


let to_string (m: t) : string =
  let identity = match m.identity with
    | Black -> "Black"
    | White -> "White"
  in
  Printf.sprintf "MIL_UNIT %s %d %d %d %d %d"
    identity m.id m.direction m.num_soliders m.morale m.leadership
