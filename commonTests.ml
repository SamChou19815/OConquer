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

let tests = [
  "array_list_test_make" >:: (fun _ -> ignore(make_starting_array_list ()));
  "array_list_test_add" >:: (fun _ -> ignore(make_added_array_list()));
  "array_list_test_get" >:: (fun _ ->
      let l = make_added_array_list () in
      assert_equal 1 (ArrayList.get 0 l);
      assert_equal 2 (ArrayList.get 1 l);
      assert_equal 3 (ArrayList.get 2 l);
      assert_equal 4 (ArrayList.get 3 l);
    );
  "array_list_test_sub" >:: (fun _ ->
      let l = make_added_array_list () in
      assert_equal [2; 3] (ArrayList.sub 1 3 l)
    )
]
