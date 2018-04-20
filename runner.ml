open Definitions

let compile_program (black_program: string) (white_program: string) : bool =
  let h class_name program =
    let f =
      let name = "./programs/src/" ^ class_name ^ ".java" in
      Unix.openfile name [O_CREAT; O_WRONLY; O_TRUNC] 0o640
    in
    let _ = Unix.single_write_substring f program 0 (String.length program) in
    Unix.close f;
  in
  h "BlackProgram" black_program; h "WhiteProgram" white_program;
  let compile_cmd = "javac -d ./programs/out ./programs/src/*.java" in
  match Unix.system compile_cmd with
  | Unix.WEXITED id -> id = 0
  | _ -> false

let get_value (r: in_channel -> 'a option) (w: 'a -> out_channel -> unit)
    (to_final_value: 'a -> 'b option) (identity: player_identity) : 'b option =
  let (cin, cout, cerr) as p =
    let args = match identity with
      | Black -> "black"
      | White -> "white"
    in
    Unix.open_process_full ("java -cp ./programs/src ProgramRunner "
                            ^ args) [||]
  in
  let rec h () : 'b option =
    let input = r cin in
    match input with
    | None -> None
    | Some v ->
      match to_final_value v with
      | Some v -> Some v
      | None ->
        let () = w v cout in
        h ()
  in
  let r = h () in
  let _ = Unix.close_process_full p in
  r
