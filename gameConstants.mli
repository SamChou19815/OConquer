(** [GameConstants] specifies a list of constants used in the game. *)

(** Game Dimension Constants *)

(** [map_width] is the width of the map. *)
val map_width : int

(** [map_height] is the height of the map. *)
val map_height : int

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
