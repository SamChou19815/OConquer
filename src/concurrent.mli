(** [Concurrent] is a module for dealing with concurrency issues. *)

(**
 * [m >>==>> f] simulates the Java's synchronized keyword.
 *
 * Requires:
 * - [m] is a mutex.
 * - [f] is a function that is performed between the mutex section code.
 * @return: f's value.
 * Effect: [f] is run in a thread safe way.
*)
val (>>==>>) : Mutex.t -> (unit -> 'a) -> 'a

(** [CountDownLatch] is the Ocaml version of Java's [CountDownLatch]. *)
module CountDownLatch : sig

  (** [t] is the type of the latch. *)
  type t

  (**
   * [create counter] will create a latch with [counter] number of count down.
   *
   * Requires: [counter] must be a natural number.
   * @return a legal latch with [counter] number of count down.
  *)
  val create : int -> t

  (**
   * [count_down latch] will count one down for the latch.
   *
   * Requires: [latch] is a legal latch.
   * @return None.
   * Effect: the [latch] is counted down for one.
  *)
  val count_down : t -> unit

  (**
   * [await latch] blocks until [latch] counted down to 0.
   *
   * Requires: [latch] is a legal latch.
   * @return None.
   * Effect: It blocks until [latch] counted down to 0.
  *)
  val await : t -> unit

end

(** [ReadWriteLock] is the Ocaml version of Java's [ReadWriteLock]. *)
module ReadWriteLock : sig

  (** [rw_lock] is the type of the read write lock. *)
  type rw_lock

  (**
   * [create ()] will create a legal read write lock.
   *
   * Requires: None.
   * @return a legal read write lock.
  *)
  val create : unit -> rw_lock

  (**
   * [lock >>=>> f] secures a block of read code in [f].
   *
   * Requires:
   * - [lock] is a legal read lock.
   * - [f] is a read function that is performed between the section.
   * @return f's value.
   * Effect: [f] is run in a thread safe way.
  *)
  val (>>=>>) : rw_lock -> (unit -> 'a) -> 'a

  (**
   * [lock >>===>> f] secures a block of write code in [f].
   *
   * Requires:
   * - [lock] is a legal write lock.
   * - [f] is a write function that is performed between the section.
   * @return f's value.
   * Effect: [f] is run in a thread safe way.
  *)
  val (>>===>>) : rw_lock -> (unit -> 'a) -> 'a

end
