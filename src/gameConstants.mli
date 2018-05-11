(** [GameConstants] specifies a list of constants used in the game. *)

(** Game Dimension Constants *)

(** [map_width] is the width of the map. *)
val map_width : int

(** [map_height] is the height of the map. *)
val map_height : int

(** Game Progress Constants *)
(** [max_turns] is the maximum number of turns of the game. *)
val max_turns : int

(** Game Interaction Constants *)

(** [training_morale_boost] is the value added to morale after training. *)
val training_morale_boost : int

(**
 * [training_leadership_boost] is the value added to leadership after training.
*)
val training_leadership_boost : int

(**
 * [retreat_morale_penalty] is the value subtracted for morale after retreating.
*)
val retreat_morale_penalty : int

(**
 * [retreat_leadership_penalty] is the value substracted from leadership after
 * retreating.
*)
val retreat_leadership_penalty : int

(**
 * [increase_soldier_factor] defines how the number of soldiers increase scales
 * with city level.
*)
val increase_soldier_factor : int

(**
 * [base_attack_damage] defines the number of soldiers died due to an single
 * attack.
*)
val base_attack_damage : int

(**
 * [fort_city_bonus_factor] defines defense factor a fort/city tile provides for
 * the military unit while engaging. The unit at fort/city will receive damage
 * lowered by a factor of this constant.
*)
val fort_city_bonus_factor : float

(**
 * [attack_morale_change] specifies the amount of change in morale for attacker
 * and defender. Attacker's morale increases by this amount and defender's
 * morale decreases by this amount.
*)
val attack_morale_change : int
