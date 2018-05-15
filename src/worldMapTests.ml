open OUnit2
open WorldMap
open Definitions
open MilUnit
open Tile

let b_mil = MilUnit.default_init Black 0 0
let w_mil = MilUnit.default_init White 1 2

let map1 = WorldMap.init b_mil w_mil

let b_mil_pos = WorldMap.get_position_by_id 0 map1
let w_mil_pos = WorldMap.get_position_by_id 1 map1

let b_mil_tile = WorldMap.get_tile_by_pos b_mil_pos map1
let w_mil_tile = WorldMap.get_tile_by_pos w_mil_pos map1

let tests = [

  "world_map_test_0" >:: (fun _ ->
      let mil_num = map1 |> WorldMap.number_of_units in
      assert_equal (1, 1) mil_num);

  (* Test cases for [id] to [position] mapping *)
  "world_map_test1" >:: (fun _ -> assert_equal (0, 0) b_mil_pos);
  "world_map_test2" >:: (fun _ -> assert_equal (9, 9) w_mil_pos);
  "world_map_test3" >:: (fun _ ->
      let none_pos = WorldMap.get_position_opt_by_id 2 map1 in
      assert_equal None none_pos);

  (* Test cases for [id] to [mil_unit] mapping *)
  "world_map_test4" >:: (fun _ ->
      let b_mil0 = WorldMap.get_mil_unit_by_id 0 map1 in
      assert_equal b_mil b_mil0
    );
  "world_map_test5" >:: (fun _ ->
      let w_mil0 = WorldMap.get_mil_unit_by_id 1 map1 in
      assert_equal w_mil w_mil0
    );
  "world_map_test6" >:: (fun _ ->
      let none_mil = WorldMap.get_mil_unit_opt_by_id 2 map1 in
      assert_equal None none_mil
    );

  (* Test cases for [position] to [mil_unit] mapping *)
  "world_map_test7" >:: (fun _ ->
      let b_mil1 = WorldMap.get_mil_unit_opt_by_pos b_mil_pos map1 in
      assert_equal (Some b_mil) b_mil1
    );
  "world_map_test8" >:: (fun _ ->
      let w_mil1 = WorldMap.get_mil_unit_opt_by_pos w_mil_pos map1 in
      assert_equal (Some w_mil) w_mil1
    );
  "world_map_test9" >:: (fun _ ->
      let none_mil = WorldMap.get_mil_unit_opt_by_pos (3,  4) map1 in
      assert_equal None none_mil
    );

  (**
   * Test cases for [position] to [tile] mapping and
   * [milUnit id] to [tile] mapping
  *)
  "world_map_test10" >:: (fun _ ->
      let b_tile = WorldMap.get_tile_by_mil_id 0 map1 in
      assert_equal b_mil_tile b_tile
    );
  "world_map_test11" >:: (fun _ ->
      let w_tile = WorldMap.get_tile_by_mil_id 1 map1 in
      assert_equal w_mil_tile w_tile
    );
  "world_map_test12" >:: (fun _ ->
      let none_tile = WorldMap.get_tile_opt_by_mil_id 2 map1 in
      assert_equal None none_tile
    );
  "world_map_test13" >:: (fun _ ->
      let b_tile1 = WorldMap.get_tile_opt_by_mil_id 0 map1 in
      assert_equal (Some b_mil_tile) b_tile1
    );

  (* Test cases for [update_mil_unit] *)
  "world_map_test14" >:: (fun _ ->
      let map1' = WorldMap.update_mil_unit 2 MilUnit.train map1 in
      assert_equal map1 map1'
    );
  "world_map_test15" >:: (fun _ ->
      let map1' = WorldMap.update_mil_unit 5 MilUnit.turn_left map1 in
      assert_equal map1 map1'
    );
  "world_map_test16" >:: (fun _ ->
      let map1' = WorldMap.update_mil_unit 0 MilUnit.train map1 in
      let mil1 = WorldMap.get_mil_unit_by_id 0 map1' in
      assert_equal (mil1 |> MilUnit.leadership)
        (b_mil |> MilUnit.train |> MilUnit.leadership)
    );
  "world_map_test17" >:: (fun _ ->
      let map1' = update_mil_unit 0 MilUnit.turn_left map1 in
      let b_mil1 = get_mil_unit_by_id 0 map1' in
      assert_equal (b_mil1|>MilUnit.direction) 1
    );
  "world_map_test18" >:: (fun _ ->
      let map1' = update_mil_unit 1 MilUnit.turn_right map1 in
      let w_mil1 = get_mil_unit_by_id 1 map1' in
      assert_equal (w_mil1|>MilUnit.direction) 1
    );

  (* Test cases for [upgrade_tile] *)
  "world_map_test19" >:: (fun _ ->
      let map1' = WorldMap.upgrade_tile b_mil_pos map1 in
      let tile1 = get_tile_by_mil_id 0 map1' in
      assert_equal tile1 (b_mil_tile|> Tile.upgrade_tile)
    );
  "world_map_test20" >:: (fun _ ->
      let map1' = WorldMap.upgrade_tile w_mil_pos map1 in
      let tile1 = get_tile_by_mil_id 1 map1' in
      assert_equal tile1 (w_mil_tile|> Tile.upgrade_tile)
    );

  (* Test cases for [move_mil_unit_forward] *)
  "world_map_test21" >:: (fun _ ->
      let map1' = WorldMap.move_mil_unit_forward 1 map1 in
      let pos1 = get_position_by_id 1 map1' in
      assert_equal pos1 (8,9)
    );
  "world_map_test22" >:: (fun _ ->
      let map1' = WorldMap.move_mil_unit_forward 0 map1 in
      let pos1 = get_position_by_id 0 map1' in
      assert_equal pos1 (1,0)
    );
  "world_map_test23" >:: (fun _ ->
      let map1' = WorldMap.move_mil_unit_forward 3 map1 in
      assert_equal map1 map1'
    );
  "world_map_test24" >:: (fun _ ->
      let m1 = (update_mil_unit 0 MilUnit.turn_right map1) in
      let map1' = WorldMap.move_mil_unit_forward 0 m1 in
      let pos1 = get_position_by_id 0 map1' in
      assert_equal pos1 (0,1)
    );

  (* Test cases for [attack] and [divide] *)
  "world_map_test25" >:: (fun _ ->
      let map1' = WorldMap.attack 3 map1 in
      assert_equal map1 map1'
    );
  "world_map_test26" >:: (fun _ ->
      let map1' = WorldMap.divide 4 map1 in
      assert_equal map1 map1'
    );
  "world_map_test27" >:: (fun _ ->
      let map1' = WorldMap.attack 0 map1 in
      assert_equal map1 map1'
    );
  "world_map_test28" >:: (fun _ ->
      let map1' = WorldMap.attack 1 map1 in
      assert_equal map1 map1'
    );
  "world_map_test29" >:: (fun _ ->
      let map1' = WorldMap.divide 0 map1 in
      let child_pos = WorldMap.get_position_by_id 2 map1' in
      assert_equal child_pos (1,0)
    );
  "world_map_test30" >:: (fun _ ->
      let map1' = WorldMap.divide 0 map1 in
      let child = WorldMap.get_mil_unit_by_id 2 map1' in
      assert_equal (identity child) (identity b_mil)
    );
  "world_map_test31" >:: (fun _ ->
      let map1' = WorldMap.divide 1 map1 in
      let child_pos = WorldMap.get_position_by_id 2 map1' in
      assert_equal child_pos (8,9)
    );
  "world_map_test32" >:: (fun _ ->
      let map1' = update_mil_unit 1 MilUnit.turn_left map1 in
      let map2' = WorldMap.divide 1 map1' in
      let child = WorldMap.get_mil_unit_opt_by_id 2 map2' in
      assert_equal child None
    );

  "world_map_test33" >:: (fun _ ->
      let map = WorldMap.init b_mil w_mil in
      let (next_map, _) = WorldMap.next WorldMap.attack map in
      assert_equal next_map map
    );
]
