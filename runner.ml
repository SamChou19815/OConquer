let compile_program (class_name: string) (p_str: string) : bool =
  let fd = Unix.openfile class_name [O_CREAT; O_WRONLY; O_TRUNC] 0o640 in
  let l = Unix.single_write_substring fd p_str 0 (String.length p_str) in
  Unix.close fd;
  if l <= 0 then false else
    let compile_cmd = "javac ./programs/" ^ class_name ^ ".java" in
    match Unix.system compile_cmd with
    | Unix.WEXITED id -> id = 0
    | _ -> false

let get_value (r: in_channel -> 'a option) (w: 'a -> out_channel -> unit)
    (to_final_value: 'a -> 'b option) (class_name: string) : 'b option =
  let (cin, cout, cerr) as p =
    Unix.open_process_full ("java -cp ./programs " ^ class_name) [||]
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
