open OUnit
open GameConstants
open Definitions
open MilUnit

let tests = [
  "mil_unit_same_test" >:: (fun () ->
      let m1 = MilUnit.default_init Black 0 0 in
      let m2 = MilUnit.default_init Black 0 1 in
      assert_equal true (MilUnit.same_mil_unit m1 m2)
    );
  "mil_unit_identity_test1" >:: (fun () ->
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
  "mil_unit_identity_string_test1" >:: (fun () ->
      let m = default_init Black 9 0 in
      assert_equal "BLACK" (identity_string m)
    );
  "mil_unit_identity_string_test2" >:: (fun () ->
      let m = default_init White 9 0 in
      assert_equal "WHITE" (identity_string m)
    );
  "mil_unit_id_test1" >:: (fun () ->
      let m = default_init White 9 0 in
      assert_equal 9 (id m)
    );
  "mil_unit_id_test2" >:: (fun () ->
      let m = default_init White 654786 0 in
      assert_equal 654786 (id m)
    );
  "mil_unit_direction_test1" >:: (fun () ->
      let m = default_init White 654786 0 in
      assert_equal 0 (direction m)
    );
  "mil_unit_direction_test2" >:: (fun () ->
      let m = default_init White 654786 1 in
      assert_equal 1 (direction m)
    );
  "mil_unit_direction_string_test1" >:: (fun () ->
      let m = default_init White 9 0 in
      assert_equal "EAST" (direction_string m)
    );
  "mil_unit_direction_string_test2" >:: (fun () ->
      let m = default_init White 9 1 in
      assert_equal "NORTH" (direction_string m)
    );
  "mil_unit_direction_string_test3" >:: (fun () ->
      let m = default_init White 9 2 in
      assert_equal "WEST" (direction_string m)
    );
  "mil_unit_direction_string_test4" >:: (fun () ->
      let m = default_init White 9 3 in
      assert_equal "SOUTH" (direction_string m)
    );
  "mil_unit_num_soldiers_test" >:: (fun () ->
      let m = default_init White 9 3 in
      assert_equal 10000 (num_soldiers m)
    );
  "mil_unit_morale_test" >:: (fun () ->
      let m1 = default_init White 9 3 in
      assert_equal 1 (morale m1)
    );
  "mil_unit_leadership_test" >:: (fun () ->
      let m = default_init White 9 3 in
      assert_equal 1 (leadership m)
    );
  "mil_unit_increase_soldier_test1" >:: (fun () ->
      let m = increase_soldier_by 5 (default_init White 9 3) in
      assert_equal 10005 (num_soldiers m)
    );
  "mil_unit_increase_soldier_test2" >:: (fun () ->
      let m = increase_soldier_by 0 (default_init White 9 3) in
      assert_equal 10000 (num_soldiers m)
    );
  "mil_unit_increase_soldier_test3" >:: (fun () ->
      let m = increase_soldier_by 1000000 (default_init White 9 3) in
      assert_equal 1010000 (num_soldiers m)
    );
  "mil_unit_turn_left_test1" >:: (fun () ->
      let m = turn_left (default_init White 9 1) in
      assert_equal 2 (direction m));

  "mil_unit_turn_left_test2" >:: (fun () ->
      let m = turn_left (default_init White 9 2) in
      assert_equal 3 (direction m)
    );
  "mil_unit_turn_left_test3" >:: (fun () ->
      let m = turn_left (default_init White 9 3) in
      assert_equal 0 (direction m)
    );
  "mil_unit_turn_right_test1" >:: (fun () ->
      let m = turn_right (default_init White 9 3) in
      assert_equal 2 (direction m)
    );
  "mil_unit_turn_right_test2" >:: (fun () ->
      let m = turn_right (default_init White 9 2) in
      assert_equal 1 (direction m)
    );
  "mil_unit_turn_right_test3" >:: (fun () ->
      let m = turn_right (default_init White 9 1) in
      assert_equal 0 (direction m)
    );
  "mil_unit_train_test" >:: (fun () ->
      let m_init = default_init Black 0 1 in
      let m_trained = train m_init in
      let diff_morale = morale m_trained - morale m_init in
      let diff_leadership = leadership m_trained - morale m_init in
      let () = assert_equal training_morale_boost diff_morale in
      assert_equal training_leadership_boost diff_leadership
    );
  "mil_unit_apply_retreat_penalty_test1" >:: (fun () ->
      let m_init = init Black 0 0 100 0 0 in
      let m_retreated = apply_retreat_penalty m_init in
      let diff_morale = morale m_init - morale m_retreated in
      let diff_leadership = leadership m_init - leadership m_retreated in
      let () = assert_equal 0 diff_morale in
      assert_equal 0 diff_leadership
    );
  "mil_unit_apply_retreat_penalty_test2" >:: (fun () ->
      let m_init = init Black 0 0 100 0 10000 in
      let m_retreated = apply_retreat_penalty m_init in
      let diff_morale = morale m_init - morale m_retreated in
      let diff_leadership = leadership m_init - leadership m_retreated in
      let () = assert_equal 0 diff_morale in
      assert_equal retreat_leadership_penalty diff_leadership
    );
  "mil_unit_apply_retreat_penalty_test3" >:: (fun () ->
      let m_init = init Black 0 0 100 10000 0 in
      let m_retreated = apply_retreat_penalty m_init in
      let diff_morale = morale m_init - morale m_retreated in
      let diff_leadership = leadership m_init - leadership m_retreated in
      let () = assert_equal retreat_morale_penalty diff_morale in
      assert_equal 0 diff_leadership
    );
  "mil_unit_apply_retreat_penalty_test4" >:: (fun () ->
      let m_init = init Black 0 0 100 10000 10000 in
      let m_retreated = apply_retreat_penalty m_init in
      let diff_morale = morale m_init - morale m_retreated in
      let diff_leadership = leadership m_init - leadership m_retreated in
      let () = assert_equal retreat_morale_penalty diff_morale in
      assert_equal retreat_leadership_penalty diff_leadership
    );
  "mil_unit_attack_test1" >:: (fun () ->
      let m1 = default_init Black 0 0 in
      let m2 = default_init Black 1 2 in
      let attack_result = attack Tile.(Empty, Empty) (m1, m2) in
      assert_equal (Some m1, Some m2) attack_result
    );
  "mil_unit_attack_test2" >:: (fun () ->
      let m1 = default_init Black 0 0 in
      let m2 = default_init White 1 3 in
      let attack_result = attack Tile.(Empty, Empty) (m1, m2) in
      let expected1 = init Black 0 0 9900 2 1 in
      let expected2 = init White 1 3 9800 0 1 in
      assert_equal (Some expected1, Some expected2) attack_result
    );
  "mil_unit_attack_test3" >:: (fun () ->
      let m1 = default_init Black 0 0 in
      let m2 = default_init White 1 3 in
      let attack_result = attack Tile.(Fort, Empty) (m1, m2) in
      let expected1 = init Black 0 0 9934 2 1 in
      let expected2 = init White 1 3 9800 0 1 in
      assert_equal (Some expected1, Some expected2) attack_result
    );
  "mil_unit_attack_test4" >:: (fun () ->
      let m1 = default_init Black 0 0 in
      let m2 = default_init White 1 3 in
      let attack_result = attack Tile.(Empty, City 3) (m1, m2) in
      let expected1 = init Black 0 0 9900 2 1 in
      let expected2 = init White 1 3 9867 0 1 in
      assert_equal (Some expected1, Some expected2) attack_result
    );
  "mil_unit_attack_test5" >:: (fun () ->
      let m1 = default_init Black 0 0 in
      let m2 = default_init White 1 3 in
      let attack_result = attack Tile.(City 4, Fort) (m1, m2) in
      let expected1 = init Black 0 0 9934 2 1 in
      let expected2 = init White 1 3 9867 0 1 in
      assert_equal (Some expected1, Some expected2) attack_result
    );
  "mil_unit_divide_test1" >:: (fun () ->
      let m = init Black 0 0 1 1 1 in
      let divide_opt = divide 1 m in
      assert_equal None divide_opt
    );
  "mil_unit_divide_test2" >:: (fun () ->
      let m = init Black 0 0 10000 1 1 in
      let divide_opt = divide 1 m in
      let expected0 = init Black 0 0 5000 1 1 in
      let expected1 = init Black 1 0 5000 1 1 in
      assert_equal (Some (expected0, expected1)) divide_opt
    );
  "mil_unit_divide_test3" >:: (fun () ->
      let m = init Black 0 0 10001 1 1 in
      let divide_opt = divide 1 m in
      let expected0 = init Black 0 0 5000 1 1 in
      let expected1 = init Black 1 0 5001 1 1 in
      assert_equal (Some (expected0, expected1)) divide_opt
    );
  "mil_unit_to_string_test" >:: (fun () ->
      let m = default_init Black 1 1 in
      let s = to_string m in
      assert_equal "MIL_UNIT BLACK 1 1 10000 1 1" s
    );
]
