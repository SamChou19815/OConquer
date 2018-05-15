open OUnit

(** [all_tests] is the collection of all tests. *)
let all_tests =
  List.flatten [
    CommonTests.tests;
    MilUnitTests.tests;
    TileTests.tests;
    WorldMapTests.tests;
    UserTests.tests;
    ConcurrentTests.tests;
    (*
       EngineTests.tests;
       ServerKernelsTests.tests;
       ProgramRunnerTests.tests;
    *)
  ]

let _ = "Final Project Test Suite" >::: all_tests |> run_test_tt_main
