open OUnit
open WorldMap
open Definitions
open MilUnit

let b_mil = MilUnit.default_init Black 0 0
let w_mil = MilUnit.default_init White 1 1

let map1 = WorldMap.init b_mil w_mil

let b_mil_pos = WorldMap.get_position_by_id 0 map1
let w_mil_pos = WorldMap.get_position_by_id 1 map1

let b_mil_tile = WorldMap.get_tile_by_pos b_mil_pos map1
let w_mil_tile = WorldMap.get_tile_by_pos w_mil_pos map1

let tests = [

  "worldMap_test_0" >:: (fun _ ->
      let mil_num = map1 |> WorldMap.number_of_units in
      assert_equal (1, 1) mil_num);

  (* Test cases for [id] to [position] mapping *)
  "worldMap_test_1" >:: (fun _ -> assert_equal (0, 0) b_mil_pos);
  "worldMap_test_2" >:: (fun _ -> assert_equal (9, 9) w_mil_pos);
  "worldMap_test_3" >:: (fun _ ->
    let none_pos = WorldMap.get_position_opt_by_id 2 map1 in
    assert_equal None none_pos);

  (* Test cases for [id] to [mil_unit] mapping *)
  "worldMap_test_4" >:: (fun _ ->
    let b_mil0 = WorldMap.get_mil_unit_by_id 0 map1 in
    assert_equal b_mil b_mil0);
  "worldMap_test_5" >:: (fun _ ->
    let w_mil0 = WorldMap.get_mil_unit_by_id 1 map1 in
    assert_equal w_mil w_mil0);
  "worldMap_test_6" >:: (fun _ ->
    let none_mil = WorldMap.get_mil_unit_opt_by_id 2 map1 in
    assert_equal None none_mil);


  (* Test cases for [position] to [mil_unit] mapping *)
  "worldMap_test_7" >:: (fun _ ->
    let b_mil1 = WorldMap.get_mil_unit_opt_by_pos b_mil_pos map1 in
    assert_equal (Some b_mil) b_mil1);
  "worldMap_test_8" >:: (fun _ ->
    let w_mil1 = WorldMap.get_mil_unit_opt_by_pos w_mil_pos map1 in
    assert_equal (Some w_mil) w_mil1);
  "worldMap_test_9" >:: (fun _ ->
    let none_mil = WorldMap.get_mil_unit_opt_by_pos (3, 4) map1 in
    assert_equal None none_mil);

  (**
   * Test cases for [position] to [tile] mapping and
   * [milUnit id] to [tile] mapping
  *)
  "worldMap_test_10" >:: (fun _ ->
    let b_tile = WorldMap.get_tile_by_mil_id 0 map1 in
    assert_equal b_mil_tile b_tile);
  "worldMap_test_11" >:: (fun _ ->
    let w_tile = WorldMap.get_tile_by_mil_id 1 map1 in
    assert_equal w_mil_tile w_tile);
  "worldMap_test_12" >:: (fun _ ->
    let none_tile = WorldMap.get_tile_opt_by_mil_id 2 map1 in
    assert_equal None none_tile);
  "worldMap_test_13" >:: (fun _ ->
    let b_tile1 = WorldMap.get_tile_opt_by_mil_id 0 map1 in
    assert_equal (Some b_mil_tile) b_tile1);


]
