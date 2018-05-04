open OUnit
open Tile
open GameConstants

(* [bad_tile_exception_test] takes in a function [f] and [input] the input
 * and runs [f input] to check if it has a [BadTileInput] exception. *)
let bad_tile_exception_test f (input: Tile.t): unit =
  let run _ = f input in
  assert_raises Tile.BadTileInput run

(* [num_soldier_city_test] takes in a integer [k] denoting city level and
 * returns the right number of soldiers the city will increase. *)
let num_soldier_city_test (k: int) =
  let m = (float_of_int k) *. GameConstants.increase_soldier_factor in
  int_of_float m

let tests = [
  (* TODO: Do we need to guard against invalid city levels, like
     [City 0], [City (-50)]? *)

  (* Tile Tests 0-5: Test [num_of_soldier_increase] function. *)
  "tile_test_soldier_increase_1" >::
  (fun _ -> (assert_equal 0 (num_of_soldier_increase Empty)));
  "tile_test_soldier_increase_2" >::
  (fun _ -> (assert_equal 0 (num_of_soldier_increase Fort)));
  "tile_test_soldier_increase_3" >::
  (fun _ -> (assert_equal (num_soldier_city_test 1)
               (num_of_soldier_increase (City 1))));
  "tile_test_soldier_increase_4" >::
  (fun _ -> (assert_equal (num_soldier_city_test 3110)
               (num_of_soldier_increase (City 3110))));
  "tile_test_soldier_increase_5" >::
  (fun _ -> bad_tile_exception_test num_of_soldier_increase Mountain);

  (* Tile tests 6-9: Test [defender_bonus] function. *)
  "tile_test_defender_bonus_1" >::
  (fun _ -> (assert_equal 1. (defender_bonus Empty)));
  "tile_test_defender_bonus_2" >::
  (fun _ -> (assert_equal fort_city_bonus_factor (defender_bonus Fort)));
  "tile_test_defender_bonus_3" >::
  (fun _ -> (assert_equal fort_city_bonus_factor (defender_bonus (City 3110))));
  "tile_test_defender_bonus_4" >::
  (fun _ -> (bad_tile_exception_test defender_bonus Mountain));

  (* Tile tests 10-13: Test [upgrade_tile] function. *)
  "tile_test_defender_bonus_1" >::
  (fun _ -> (assert_equal Fort (upgrade_tile Empty)));
  "tile_test_defender_bonus_1" >::
  (fun _ -> (assert_equal (City 1) (upgrade_tile Fort)));
  "tile_test_defender_bonus_1" >::
  (fun _ -> (assert_equal (City 42) (upgrade_tile (City 41))));
  "tile_test_defender_bonus_1" >::
  (fun _ -> (bad_tile_exception_test upgrade_tile Mountain));
]
