(** [Runner] defines how a Java program interacts with the main program. *)

open Definitions

(** [running_program] is an abtract type of the handle of a running program. *)
type running_program

(**
 * [compile_program is_temp bp wp] will compile the given black and white
 * programs [bp] [wp]. Depending on whether [is_temp] is true, the output will
 * be in ["./programs/out-temp"] or in ["./programs/out"].
 * By default, [is_temp = false].
 *
 * Require:
 * - [is_temp] can be either true/false.
 * - [bp] [wp] would better be black and white programs.
 * @return whether the given programs [bp] [wp] compile.
 * Effect: If program compiles, .class files will be generated in the specified
 * directory.
*)
val compile_program : ?is_temp:bool -> string -> string -> bool

(**
 * [compile_program black_program white_program] compiles a Java program with
 * the specified [class_name] and [program_string].
 * If it compiles, a compiled .class file will be generated and return true.
 * Otherwise, it will return false.
 *
 * Requires: [black_program] [white_program] are code string of black and
 * white program.
 * @return [Some p] where [p] is the handle of running program or [None] if it
 * does not compile.
 * Effects: Some valid .class files will be generated in the directory
 * ./programs/out if it compiles and it will start to run.
*)
val start_program : string -> string -> running_program option

(**
 * [get_value reader writer to_final_value identity p] obtains a value from a
 * Java program [p].
 * Getting the value is based on interactive IO between two programs, so the
 * user of this function is responsible for setting up a IO protocol for that.
 * The interaction allows the other program to query from values from the
 * host program and use those information to get the final output.
 *
 * Requires:
 * - [reader] is responsible for reading a line and parse that into
 *   a data structure that is later used. The data structure should be
 *   compatible both in the case of querying for data and in the case of
 *   outputing final result.
 * - [writer] is responsible for producing a string for writing the query result
 *   based on the input given by the [reader]. The data structure given is
 *   guaranteed to be valid. Error is handled by this function.
 * - [to_final_value] maps an input object to Some final value, or [None] if the
 *   input is not a final value.
 * - [identity] is the identity of the player's program.
 * - [p] is the running program.
 * @return the result of the running the program.
*)
val get_value : (string -> 'a) -> ('a -> string)
  -> ('a -> 'b option) -> player_identity -> running_program -> 'b option

(**
 * [stop_program p] will end the running program [p]. It should be called only
 * when it's running.
 *
 * Requires: [p] has not been stopped yet.
 * @return None.
 * Effect: [p] has been stopped. It cannot be stopped again.
*)
val stop_program : running_program -> unit
