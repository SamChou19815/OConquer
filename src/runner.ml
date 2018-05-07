open Definitions

type running_program = in_channel * out_channel

let compile_program ?(is_temp: bool = false) (bp: string) (wp: string) : bool =
  let open Unix in
  let program_writer class_name code =
    let f =
      let name = "./programs/src/" ^ class_name ^ ".java" in
      openfile name [O_CREAT; O_WRONLY; O_TRUNC] 0o640
    in
    let _ = single_write_substring f code 0 (String.length code) in
    close f;
  in
  (* Write code to filesystem. *)
  program_writer "BlackProgram" bp;
  program_writer "WhiteProgram" wp;
  (* Compile Code *)
  let out_dir = if is_temp then "./programs/out-temp" else "./programs/out" in
  let cmd = "javac -d " ^ out_dir ^ " ./programs/src/*.java" in
  match system cmd with
  | WSIGNALED _ | WSTOPPED _ -> false
  | WEXITED id -> id = 0

let start_program (bp: string) (wp: string) : running_program option =
  if compile_program bp wp then
    Some (Unix.open_process "java -cp ./programs/out ProgramRunner")
  else None

let get_value
    (reader: string -> 'a)
    (writer: 'a -> string)
    (to_final_value: 'a -> 'b option)
    (identity: player_identity)
    (cin, cout: running_program): 'b option =
  (* Print request for running program in Java. *)
  let () =
    output_string cout (
      match identity with
      | Black -> "BLACK\n"
      | White -> "WHITE\n"
    );
    flush cout;
    let confirmation_line = input_line cin in
    if confirmation_line = "CONFIRMED!" then ()
    else failwith ("Bad confirmation line: " ^ confirmation_line)
  in
  (* Run interactive io until the end. *)
  let rec interactive_io () : 'b option =
    let line = input_line cin in
    let input = reader line in
    match to_final_value input with
    | Some v -> Some v
    | None ->
      let () =
        let s = writer input in
        output_string cout s;
        output_char cout '\n';
        flush cout
      in
      interactive_io ()
  in
  interactive_io ()

let stop_program (p: running_program)  =
  let (_, cout) = p in
  let () =
    output_string cout "END\n";
    flush cout
  in
  ignore(Unix.close_process p)
