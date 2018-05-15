open OUnit2
open Tile
open GameConstants

(** [test_exc] takes in a function [f] and [input] the input
 * and runs [f input] to check if it has a [BadTileInput] exception. *)
let test_exc f (input: Tile.t) _ : unit =
  assert_raises BadTileInput (fun () -> f input)

(** [num_soldier_city_test] takes in a integer [k] denoting city level and
 * returns the right number of soldiers the city will increase. *)
let num_soldier_city_test : int -> int = ( * ) increase_soldier_factor

(** [test_equal v1 v2 _] tests whether [v1] [v2] are equal. *)
let test_equal v1 v2 _ = assert_equal v1 v2

let tests = [
  (** Tile Tests 1-5: Test [num_of_soldier_increase] function. *)
  "tile_soldiers_incr_test1" >::
  test_equal 0 (num_of_soldier_increase Empty);
  "tile_soldiers_incr_test2" >::
  test_equal 0 (num_of_soldier_increase Fort);
  "tile_soldiers_incr_test3" >::
  test_equal (num_soldier_city_test 1) (num_of_soldier_increase (City 1));
  "tile_soldiers_incr_test4" >::
  test_equal (num_soldier_city_test 3110) (num_of_soldier_increase (City 3110));
  "tile_soldiers_incr_test5" >:: test_exc num_of_soldier_increase Mountain;

  (** Tile tests 6-9: Test [defender_bonus] function. *)
  "tile_defender_bonus_test1" >:: test_equal 1. (defender_bonus Empty);
  "tile_defender_bonus_test2" >::
  test_equal fort_city_bonus_factor (defender_bonus Fort);
  "tile_defender_bonus_test3" >::
  test_equal fort_city_bonus_factor (defender_bonus (City 3110));
  "tile_defender_bonus_test4" >:: test_exc defender_bonus Mountain;

  (** Tile tests 10-13: Test [upgrade_tile] function. *)
  "tile_defender_bonus_test1" >:: test_equal Fort (upgrade_tile Empty);
  "tile_defender_bonus_test2" >:: test_equal (City 1) (upgrade_tile Fort);
  "tile_defender_bonus_test3" >:: test_equal (City 42) (upgrade_tile (City 41));
  "tile_defender_bonus_test4" >:: test_exc upgrade_tile Mountain;
]
