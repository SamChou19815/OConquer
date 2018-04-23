open OUnit

(** [all_tests] is the collection of all tests. *)
let all_tests =
  List.flatten [
    CommonTests.tests;
    ProgramRunnerTests.tests;
  ]

let suite = "Final Project Test Suite" >::: all_tests

let _ = run_test_tt_main suite
