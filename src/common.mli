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
 * [repeats n f input] is mathematically equivalent to f^n(input).
 *
 * Requires:
 * - [n] is a natural number.
 * - [f] has no visible side effects.
 * - [input] is a valid input to [f].
 * @return f^n(input).
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
module PosMap : (Map.S with type key = Position.t)

(** [IntMap] is a map where the key is always an int. *)
module IntMap : (Map.S with type key = int)

(** [FloatMap] is a map where the key is always an float. *)
module FloatMap : (Map.S with type key = float)

(** [StringMap] is a map where the key is always a string. *)
module StringMap : (Map.S with type key = string)

(** [HashSet] is a mutable HashSet. *)
module HashSet : sig

  (** ['a t] is the abstract type of the [HashSet]. *)
  type 'a t

  (**
   * [make ()] makes a new set with empty content.
   *
   * Requires: None.
   * @return: an empty set.
   * Effect: None.
  *)
  val make : unit -> 'a t

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

(** [ArrayList] is a mutable List structure, similar to Java's ArrayList. *)
module ArrayList : sig

  (** ['a t] is the type of the array list with elements with type ['a] *)
  type 'a t

  (**
   * [make template] creates an array list with content type same as that of
   * [template].
   *
   * Requires: [template] can be anything.
   * @return an constructed legal empty array list.
  *)
  val make : 'a -> 'a t

  (**
   * [size l] reports the size of the array list.
   *
   * Requires: [l] is a legal array list.
   * @return size of the array list.
  *)
  val size : 'a t -> int

  (**
   * [get i l] gets the content at index [index] of the given [l].
   *
   * Requires:
   * - [0 <= i < length l].
   * - [l] is a legal array list.
   * @return content at index [i] of [l].
   * @raise Invalid_argument ["index out of bounds"] if [i] fails the
   * requirement.
  *)
  val get : int -> 'a t -> 'a

  (**
   * [add v l] adds [v] to the end of [l].
   *
   * Requires:
   * - [v] can be any value.
   * - [l] is a legal array list.
   * @return None.
   * Effect: [v] is added to [l], where [l] is modified in-place.
  *)
  val add : 'a -> 'a t -> unit

  (**
   * [sub s t l] creates a list of elements in the array list [l] from [s]
   * (inclusive) to [t] (exclusive).
   * If [t >= l], the result will be an empty list.
   *
   * Requires:
   * - [s] can be any integer greater than or equal to 0.
   * - [t] can be any integer less than [size l].
   * - [l] is a legal array list.
   * @return a sub list of the original array list [l] from [s] to [t].
   * @raise Invalid_argument ["index out of bounds"] if [s] is less than 0.
  *)
  val sub : int -> int -> 'a t -> 'a list

end
