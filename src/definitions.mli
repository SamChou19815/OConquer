(** [Definitions] contains the global definitions of the game. *)

(** [player_identity] is simply [Black] or [White]. *)
type player_identity =
  | Black (** Black Player *)
  | White (** White Player *)

(** [command] is a collection of all supported program commands in the game. *)
type command =
  | DoNothing (** Literally does nothing. *)
  | Attack (** Attack the military unit ahead, or do nothing if impossible. *)
  | Train (** Train increases the fighting ability of a military unit. *)
  | TurnLeft (** Simply turns left. *)
  | TurnRight (** Simply turns right. *)
  | MoveForward (** Move forward, or do nothing if impossible. *)
  | RetreatBackward (** Turn back and retreat, or just turn back if blocked *)
  | Divide (** Divide the military unit into two. *)
  | Upgrade (** Upgrade the tile the military unit is current on. *)

(** [game_status] is a collection of all possible game status in the game. *)
type game_status =
  | BlackWins (** The game ends with black side winning. *)
  | WhiteWins (** The game ends with white side winning. *)
  | Draw (** The game ends with a draw. *)
  | InProgress (** The game is still in progress. *)
