open OUnit
open Definitions
open MilUnit

let tests = [

  "mil_unit_trivial_test" >:: (fun () -> ());

  "mil_unit_same_test" >:: (fun () ->
      let m1 = MilUnit.default_init Black 0 0 in
      let m2 = MilUnit.default_init Black 0 1 in
      assert_equal true (MilUnit.same_mil_unit m1 m2)
    );

  "mil_unit_identity_test" >:: (fun () ->
      let m1 = MilUnit.default_init Black 0 0 in
      let m2 = MilUnit.default_init White 0 1 in
      assert_equal Black (MilUnit.identity m1);
      assert_equal White (MilUnit.identity m2)
    );

  "mil_unit_identity_test2" >:: (fun () ->
      let m1 = default_init White 123 3 in
      let m2 = default_init Black 123 3 in
      assert_equal false (same_mil_unit m1 m2)
    );

  "mil_unit_identity_test3" >:: (fun () ->
      let m1 = default_init Black 9 0 in
      let m2 = default_init Black 9 2 in
      assert_equal true (same_mil_unit m1 m2)
    );

  "mil_identity_string" >:: (fun () ->
      let m1 = default_init Black 9 0 in
      assert_equal "BLACK" (identity_string m1)
    );

  "mil_identity_string2" >:: (fun () ->
      let m1 = default_init White 9 0 in
      assert_equal "WHITE" (identity_string m1)
    );


  "mil_id" >:: (fun () ->
      let m1 = default_init White 9 0 in
      assert_equal 9 (id m1)
    );

  "mil_id2" >:: (fun () ->
      let m1 = default_init White 654786 0 in
      assert_equal 654786 (id m1)
    );

  "mil_direction" >:: (fun () ->
      let m1 = default_init White 654786 0 in
      assert_equal 0 (direction m1)
    );

  "mil_direction2" >:: (fun () ->
      let m1 = default_init White 654786 1 in
      assert_equal 1 (direction m1)
    );

  "mil_direction_string" >:: (fun () ->
      let m1 = default_init White 9 0 in
      assert_equal "EAST" (direction_string m1)
    );

  "mil_direction_string2" >:: (fun () ->
      let m1 = default_init White 9 1 in
      assert_equal "NORTH" (direction_string m1)
    );

  "mil_direction_string2" >:: (fun () ->
      let m1 = default_init White 9 2 in
      assert_equal "WEST" (direction_string m1)
    );

  "mil_direction_string2" >:: (fun () ->
      let m1 = default_init White 9 3 in
      assert_equal "SOUTH" (direction_string m1)
    );

  "mil_num_soldiers" >:: (fun () ->
      let m1 = default_init White 9 3 in
      assert_equal 10000 (num_soldiers m1)
    );

  "mil_morale" >:: (fun () ->
      let m1 = default_init White 9 3 in
      assert_equal 1 (morale m1)
    );


  "mil_leadership" >:: (fun () ->
      let m1 = default_init White 9 3 in
      assert_equal 1 (leadership m1)
    );

  "increase_soldier" >:: (fun () ->
      let m1 = increase_soldier_by 5 (default_init White 9 3) in
      assert_equal 10005 (num_soldiers m1)
    );


  "increase_soldier2" >:: (fun () ->
      let m1 = increase_soldier_by 0 (default_init White 9 3) in
      assert_equal 10000 (num_soldiers m1)
    );


  "increase_soldier3" >:: (fun () ->
      let m1 = increase_soldier_by 1000000 (default_init White 9 3) in
      assert_equal 1010000 (num_soldiers m1)
    );

  "turn_left" >:: (fun () ->
      let m1 = turn_left (default_init White 9 1) in
      assert_equal 2 (direction m1));

  "turn_left2" >:: (fun () ->
      let m1 = turn_left (default_init White 9 2) in
      assert_equal 3 (direction m1)
    );

  "turn_left3" >:: (fun () ->
      let m1 = turn_left (default_init White 9 3) in
      assert_equal 0 (direction m1)
    );

  "turn_right" >:: (fun () ->
      let m1 = turn_right (default_init White 9 3) in
      assert_equal 2 (direction m1)
    );

  "turn_right1" >:: (fun () ->
      let m1 = turn_right (default_init White 9 2) in
      assert_equal 1 (direction m1)
    );

  "turn_right2" >:: (fun () ->
      let m1 = turn_right (default_init White 9 1) in
      assert_equal 0 (direction m1)
    );
]
