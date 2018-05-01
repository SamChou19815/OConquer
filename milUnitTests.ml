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
  (* "mil_unit_identity_test2" >:: (fun ()->
    let m1 = ) *)
]
