(** [player_identity] is simply [Black] or [White]. *)
type player_identity = Black | White

(** [command] is a collection of all supported program commands in the game. *)
type command = DoNothing | Attack | Train | TurnLeft | TurnRight | MoveForward
             | RetreatBackward | Divide | Upgrade

(** [game_status] is a collection of all possible game status in the game. *)
type game_status = BlackWins | WhiteWins | Draw | InProgress
