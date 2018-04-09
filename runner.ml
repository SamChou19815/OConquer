let compile_program (class_name: string) : bool =
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
