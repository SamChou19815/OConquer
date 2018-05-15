(**
 * [m >>==>> f] simulates the Java's synchronized keyword.
 *
 * Requires:
 * - [m] is a mutex.
 * - [f] is a function that is performed between the mutex section code.
 * @return: f's value.
 * Effect: [f] is run in a thread safe way.
*)
let (>>==>>) (m: Mutex.t) (f: unit -> 'a) : 'a =
  let () = Mutex.lock m in
  let v = f () in
  let () = Mutex.unlock m in
  v

module CountDownLatch = struct

  type t = {
    mutex: Mutex.t;
    condition: Condition.t;
    mutable counter: int
  }

  let create (counter: int) : t =
    if counter < 0 then failwith "Counter must be a natural number."
    else {
      mutex = Mutex.create ();
      condition = Condition.create ();
      counter
    }

  let count_down (latch: t) : unit =
    latch.mutex >>==>> fun () -> (
      latch.counter <- latch.counter - 1;
      Condition.broadcast latch.condition;
    )

  let await (latch: t) : unit =
    latch.mutex >>==>> fun () ->
    while latch.counter = 0 do
      Condition.wait latch.condition latch.mutex
    done

end

module ReadWriteLock = struct

  type rw_lock = {
    mutex: Mutex.t;
    condition: Condition.t;
    mutable num_readers: int;
    mutable num_writers_waiting: int;
    (* number of times held by current writer *)
    mutable held_count: int;
    mutable writer: Thread.t option;
  }

  let create () : rw_lock = {
    mutex = Mutex.create ();
    condition = Condition.create ();
    num_readers = 0;
    num_writers_waiting = 0;
    held_count = 0;
    writer = None;
  }

  let (>>=>>) (lock: rw_lock) (f: Mutex.t -> 'a) : 'a =
    (* lock *)
    let () = lock.mutex >>==>> fun () -> (
        while lock.num_writers_waiting > 0 || lock.writer <> None do
          Condition.wait lock.condition lock.mutex
        done;
        lock.num_readers <- lock.num_readers + 1
      )
    in
    let v = f lock.mutex in
    (* unlock *)
    let () = lock.mutex >>==>> fun () -> (
        lock.num_readers <- lock.num_readers - 1;
        (* When there are writers waiting, we don't need to notify readers,
         * because they will not be blocked. *)
        if lock.num_writers_waiting > 0 then Condition.broadcast lock.condition
      )
    in
    v

  let (>>===>>) (lock: rw_lock) (f: Mutex.t -> 'a) : 'a =
    (* lock *)
    let () =
      let me = Thread.self () in
      lock.mutex >>==>> fun () ->
      if lock.writer = Some me then lock.held_count <- lock.held_count + 1
      else (
        lock.num_writers_waiting <- lock.num_writers_waiting + 1;
        while lock.num_readers > 0 || lock.writer <> None do
          (* When readers are reading this
           * or the writer is held by another writer. *)
          Condition.wait lock.condition lock.mutex
        done;
        (* The writer can write now, so there will be one less waiting writer.
         * Then the current writer gets the lock. *)
        lock.num_writers_waiting <- lock.num_writers_waiting - 1;
        lock.writer <- Some me
      )
    in
    let v = f lock.mutex in
    (* unlock *)
    let () = lock.mutex >>==>> fun () -> (
        lock.held_count <- lock.held_count - 1;
        if lock.held_count > 0 then ()
        else
          let () = lock.writer <- None in
          Condition.broadcast lock.condition
      )
    in
    v

end
