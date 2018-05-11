open OUnit
open Common

(** [make_starting_array_list ()] creates an array list for starting test. *)
let make_starting_array_list () : int ArrayList.t = ArrayList.make 0

(** [make_added_array_list ()] creates an array list with something added.  *)
let make_added_array_list () : int ArrayList.t =
  let l = make_starting_array_list () in
  ArrayList.add 1 l;
  ArrayList.add 2 l;
  ArrayList.add 3 l;
  ArrayList.add 4 l;
  l

(** [make_added_hash_set ()] creates an hash set with something added.  *)
let make_added_hash_set () : int HashSet.t =
  let l = HashSet.make () in
  HashSet.add 42 l;
  HashSet.add 3110 l;
  HashSet.add 56 l;
  l

(** [list_compare_helper l1 l2] helps to compare whether two lists are equal. *)
let list_compare_helper (l1:int list) (l2:int list): bool =
  let l1_sorted = List.sort_uniq Pervasives.compare l1 in
  let l2_sorted = List.sort_uniq Pervasives.compare l2 in
  l1_sorted = l2_sorted

let tests = [
  (* Tests for ArrayList *)
  "array_list_test_make" >:: (fun () -> ignore(make_starting_array_list ()));
  "array_list_test_add" >:: (fun () -> ignore(make_added_array_list()));
  "array_list_test_get" >:: (fun () ->
      let l = make_added_array_list () in
      assert_equal 1 (ArrayList.get 0 l);
      assert_equal 2 (ArrayList.get 1 l);
      assert_equal 3 (ArrayList.get 2 l);
      assert_equal 4 (ArrayList.get 3 l);
    );
  "array_list_test_sub" >:: (fun () ->
      let l = make_added_array_list () in
      assert_equal [] (ArrayList.sub 0 0 l);
      assert_equal [2; 3] (ArrayList.sub 1 3 l)
    );

  (* Tests for Hashset *)
  "hash_set_test_make" >:: (fun () -> ignore(HashSet.make ()));
  "hash_set_test_add" >:: (fun () -> ignore(make_added_hash_set ()));
  "hash_set_test_sub_1" >:: (fun () ->
      let l1 = HashSet.make () in
      assert_equal [] (HashSet.elem l1)
    );
  "hash_set_test_sub_2" >:: (fun () ->
      let l1 = make_added_hash_set () in
      assert_equal true (list_compare_helper (HashSet.elem l1) [42; 3110; 56])
    );
  "hash_set_test_clear" >:: (fun () ->
      let l1 = make_added_hash_set () in
      let _ = HashSet.clear l1 in
      assert_equal (HashSet.elem (HashSet.make ())) (HashSet.elem l1)
    );
]
