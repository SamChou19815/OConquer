(**
 * [Common] defines some common data structures and helper functions that
 * are frequently used.
*)

(**
 * [compute_and_print_running_time f] runs the function [f] to get result and
 * prints the running time of the function [f].
 * It is useful for profiling.
 *
 * Requires: [f] is a function that computes something.
 * @return the computation result.
 * Effect: Running time has been printed to console.
*)
val compute_and_print_running_time : (unit -> 'a) -> 'a

(**
 * [run_and_print_running_time f] runs the function [f] and
 * prints the running time of the function [f].
 * It is useful for profiling.
 *
 * Requires: [f] is a function that runs something.
 * @return None.
 * Effect: Running time has been printed to console.
*)
val run_and_print_running_time : (unit -> unit) -> unit

(**
 * [repeats n f input] is mathematically equivalent to `f^n(input)`.
 *
 * Requires:
 * - [n] is a natural number.
 * - [f] has no visible side effects.
 * - [input] is a valid input to [f].
 * @return `f^n(input)`.
*)
val repeats : int -> ('a -> 'a) -> 'a -> 'a

(**
 * [Position] is an adapter for the [Map] module. It defines how tuple
 * positions should be ordered.
*)
module Position : sig
  include Map.OrderedType with type t = int * int

  (**
   * [to_string p] outputs the standard string representation of the
   * position [p].
   * The representation is used as a contract in IO.
   *
   * Requires: [p] is a legal position.
   * @return: the standard string representation of the position [p].
  *)
  val to_string : t -> string
end

(** [PosMap] is a map where the key is always a tuple position. *)
module PosMap : sig
  include Map.S with type key = Position.t

end

(** [IntMap] is a map where the key is always an int. *)
module IntMap : sig
  include Map.S with type key = int
end

(** [HashSet] is a mutable HashSet. *)
module HashSet : sig

  (** ['a t] is the abstract type of the [HashSet]. *)
  type 'a t

  (**
   * [create ()] creates a new set with empty content.
   *
   * Requires: None.
   * @return: an empty set.
   * Effect: None.
  *)
  val create : unit -> 'a t

  (**
   * [clear set] empties the set.
   *
   * Requires: [set] is a legal [HashSet].
   * @return: None.
   * Effect: the given [set] is emptied.
  *)
  val clear : 'a t -> unit

  (**
   * [add i set] adds [i] to the given [set].
   *
   * Requires:
   * - [i] can be anything.
   * - [set] is a legal [IntHashSet].
   * @return: None.
   * Effect: [i] is added to the given [set].
  *)
  val add : 'a -> 'a t -> unit

  (**
   * [elem set] outputs all the elements in the given [set]. The order is not
   * defined.
   *
   * Requires: [set] is a legal [IntHashSet].
   * @return: a list of all ints in [set].
   * Effect: None.
  *)
  val elem : 'a t -> 'a list
end
