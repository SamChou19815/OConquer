open OUnit
open Tile

type t = Empty | Mountain | Fort | City of int

let tests = [
  "tile_test_works_1" >:: (fun _ -> ());
  "tile_test_works_2" >:: (fun _ -> (assert_equal Empty Empty));

  "tile_test_num_increase" >::
  (fun _ -> (assert_equal 0 (num_of_soldier_increase Empty)));
]
