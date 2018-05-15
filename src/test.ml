open OUnit2

(** [all_tests] is the collection of all tests. *)
let all_tests =
  List.flatten [
    CommonTests.tests;
    MilUnitTests.tests;
    TileTests.tests;
    WorldMapTests.tests;
    UserTests.tests;
    ConcurrentTests.tests;
    EngineTests.tests;
    ProgramRunnerTests.tests;
    ServerKernelsTests.tests;
  ]

(** [suite] is the test suite. *)
let suite = "FinalProjectTestSuite" >::: all_tests

let () = run_test_tt_main suite
