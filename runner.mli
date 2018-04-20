(** [Runner] defines how a Java program interacts with the main program. *)

open Definitions

(**
 * [compile_program black_program white_program] compiles a Java program with
 * the specified [class_name] and [program_string].
 * If it compiles, a compiled .class file will be generated and return true.
 * Otherwise, it will return false.
 *
 * Requires: [black_program] [white_program] are code string of black and
 * white program.
 * @return whether the program with the specified [class_name] compiles.
 * Effects: a valid .class file will be generated in the directory ./programs
 * if it compiles.
*)
val compile_program : string -> string -> bool

(**
 * [get_value reader writer to_final_value identity] obtains a value from a
 * Java program with name [class_name].
 * Getting the value is based on interactive IO between two programs, so the
 * user of this function is responsible for setting up a IO protocol for that.
 * The interaction allows the other program to query from values from the
 * host program and use those information to get the final output.
 *
 * Requires:
 * - [reader] is responsible for reading the input stream and parse that into
 *   a data structure that is later used. The data structure should be
 *   compatible both in the case of querying for data and in the case of
 *   outputing final result.
 * - [writer] is responsible for writing the query result based on the input
 *   given by the [reader]. The data structure given is guaranteed to be valid.
 *   Error is handled by this function.
 * - [to_final_value] maps an input object to Some final value, or [None] if the
 *   input is not a final value.
 * - [identity] is the identity of the player's program.
 * @return the result of the running the program.
*)
val get_value : (in_channel -> 'a option) -> ('a -> out_channel -> unit)
  -> ('a -> 'b option) -> player_identity -> 'b option
