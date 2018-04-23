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

let identity_string (m: t) :string =
  match m.identity with
  | Black -> "BLACK"
  | White -> "WHITE"

let id (m: t) : int = m.id

let direction (m: t) : int = m.direction

let direction_string (m: t) : string =
  match m.direction with
  | 0 -> "EAST"
  | 1 -> "NORTH"
  | 2 -> "WEST"
  | 3 -> "SOUTH"
  | _ -> failwith "Corrupted Direction Data!"

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
 * If the resultant morale is not positive, it will be reset to 1.
 * If [a] is not-positive, it has no effect.
 *
 * Requires: [m] is a legal military unit.
 * Returns: the result of reducing the morale of the military unit.
*)
let reduce_morale_by (amount: int) (m: t) : t =
  if amount > 0 then
    let morale = m.morale - amount in
    let morale_normalized = if morale < 1 then 1 else morale in
    { m with morale = morale_normalized }
  else m

(**
 * [reduce_leadership_by a m] reduces the leadership of the military unit [m]
 * by [a].
 * If the resultant leadership is not positive, it will be reset to 1.
 * If [a] is not-positive, it has no effect.
 *
 * Requires: [m] is a legal military unit.
 * Returns: the result of reducing the morale of the military unit.
*)
let reduce_leadership_by (amount: int) (m: t) : t =
  if amount > 0 then
    let leadership = m.leadership - amount in
    let leadership_normalized = if leadership < 1 then 1 else leadership in
    { m with leadership = leadership_normalized }
  else m

let apply_retreat_penalty (m: t) : t =
  m |> reduce_morale_by retreat_morale_penalty
  |> reduce_leadership_by retreat_leadership_penalty

(**
 * [logistic x] is the function `1/(1+e^(-x))`.
 *
 * Requires: None.
 * @return `1/(1+e^(-x))`.
*)
let logistic (x: float) : float = 1. /. (1. +. exp (0. -. x))

(**
 * [single_round_attack_power attacker defender_tile] computes the attacking
 * power of [attacker] when the defender is on [defender_tile].
 *
 * Requires:
 * - [attacker] is the military unit representing attacker.
 * - [defender_tile] is the defender's current tile.
 * @return pure attacking power of the [attacker] to defender on the
 * [defender_tile].
*)
let single_round_attack_power (attacker: t) (defender_tile: Tile.t) : int =
  let attacking_output_raw =
    attacker.num_soliders * attacker.leadership * attacker.morale
    |> float_of_int
    |> logistic
    |> ( *. ) (float_of_int base_attack_damage)
  in
  int_of_float (attacking_output_raw /. (Tile.defender_bonus defender_tile))

let attack (t1, t2: Tile.t * Tile.t) (m1, m2: t * t) : (t option * t option) =
  (* Prevent programmer error to attack same side *)
  if m1.identity = m2.identity then (Some m1, Some m2)
  else
    (* Let attacker attack first, then let defender retaliate. *)
    let m1 = { m1 with morale = m1.morale + attack_morale_change } in
    let m1_attack_power = single_round_attack_power m1 t2 in
    let m2_soldiers_left = m2.num_soliders - m1_attack_power in
    if m2_soldiers_left <= 0 then (Some m1, None) (* m2 is gone *)
    else
      (* Apply attack result *)
      let m2 = { m2 with
                 num_soliders = m2_soldiers_left;
                 morale = m2.morale - attack_morale_change
               } in
      (* Retaliate! *)
      let m2_attack_power = single_round_attack_power m2 t1 in
      let m1_soliders_left = m1.num_soliders - m2_attack_power in
      if m1_soliders_left <= 0 then (None, Some m2) (* m1 is gone *)
      else (Some { m1 with num_soliders = m1_soliders_left }, Some m2)

let divide (next_id: int) (m: t) : (t * t) option =
  if m.num_soliders <= 1 then None
  else
    (* Divide number of soldiers. *)
    let num_soliders_1 = m.num_soliders / 2 in
    let num_soliders_2 = m.num_soliders - num_soliders_1 in
    let m1 = { m with num_soliders = num_soliders_1 } in
    let m2 = { m with id = next_id; num_soliders = num_soliders_2 } in
    Some (m1, m2)

let to_string (m: t) : string =
  let identity = identity_string m in
  Printf.sprintf "MIL_UNIT %s %d %d %d %d %d"
    identity m.id m.direction m.num_soliders m.morale m.leadership
