open OUnit
open Tile
open GameConstants

let num_soldier_exception_test (f: Tile.t -> int) (input: Tile.t): unit =
  let run _ = f input in
  assert_raises Tile.BadTileInput run

let num_soldier_city_test (k: int) =
  let m = (float_of_int k) *. GameConstants.increase_soldier_factor in
  int_of_float m

let tests = [
  (* Tile Tests 0-5: Test [num_of_soldier_increase] function. *)
  "tile_test_soldier_increase-1" >::
  (fun _ -> (assert_equal 0 (num_of_soldier_increase Empty)));
  "tile_test_soldier_increase-2" >::
  (fun _ -> (assert_equal 0 (num_of_soldier_increase Fort)));
  "tile_test_soldier_increase-3" >::
  (fun _ -> (assert_equal (num_soldier_city_test (-50))
               (num_of_soldier_increase (City (-50)))));
  "tile_test_soldier_increase-4" >::
  (fun _ -> (assert_equal (num_soldier_city_test 0)
               (num_of_soldier_increase (City 0))));
  "tile_test_soldier_increase-5" >::
  (fun _ -> (assert_equal (num_soldier_city_test 3110)
               (num_of_soldier_increase (City 3110))));
  "tile_test_soldier_increase-6" >::
  (fun _ -> num_soldier_exception_test num_of_soldier_increase Mountain);

  

]
