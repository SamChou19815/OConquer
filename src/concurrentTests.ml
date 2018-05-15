open OUnit2
open Concurrent

let tests = [
  (* Ensure the synchronized section is safe. *)
  "concurrent_synchronized_and_latch_test" >:: (fun _ ->
      let repeat = 100000 in
      let a = ref 0 in
      let lock = Mutex.create () in
      let latch = CountDownLatch.create 2 in
      (** Simulatenously increase and decrease the number. *)
      let t1 () =
        for i = 1 to repeat do
          lock >>==>> fun () -> incr a
        done;
        CountDownLatch.count_down latch
      in
      let t2 () =
        for i = 1 to repeat do
          lock >>==>> fun () -> decr a
        done;
        CountDownLatch.count_down latch
      in
      let _ = Thread.create t1 () in
      let _ = Thread.create t2 () in
      CountDownLatch.await latch;
      assert_equal 0 !a
    );

  (* Test the rw lock on an array. *)
  "concurrent_rw_lock_test" >:: (fun _ ->
      let len = 100000 in
      let array = Array.make len 0 in
      let unsafe_write () =
        (* Create a randomized array that sum to 0 *)
        let () = Random.self_init () in
        let c = ref 0 in
        for i = 0 to (len - 2) do
          let r = Random.int 100 - 50 in
          let () = c := !c + r in
          array.(i) <- r
        done;
        array.(len - 1) <- (0 - !c)
      in
      let unsafe_read () =
        (* Expect an array that sum to 0 *)
        let c = ref 0 in
        for i = 0 to (len - 1) do
          c := !c + array.(i)
        done;
        assert_equal 0 !c
      in
      let repeat = 1000 in
      let lock = ReadWriteLock.create () in
      let latch = CountDownLatch.create (repeat * 2) in
      let safe_read () =
        ReadWriteLock.(lock >>=>> unsafe_read);
        CountDownLatch.count_down latch
      in
      let safe_write () =
        ReadWriteLock.(lock >>===>> unsafe_write);
        CountDownLatch.count_down latch
      in
      for i = 1 to repeat do
        let _ = Thread.create safe_read () in
        let _ = Thread.create safe_write () in
        ()
      done;
      CountDownLatch.await latch
    );
]
