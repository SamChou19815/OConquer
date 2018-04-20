let compute_and_print_running_time (f: unit -> 'a) : 'a =
  let t1 = Unix.gettimeofday() in
  let result = f () in
  let t2 = Unix.gettimeofday() in
  let diff = t2 -. t1 in
  let () = print_endline ("Running Time: " ^ string_of_float diff) in
  result

let run_and_print_running_time (f: unit -> unit) : unit =
  let t1 = Unix.gettimeofday() in
  let () = f () in
  let t2 = Unix.gettimeofday() in
  let diff = t2 -. t1 in
  print_endline ("Running Time: " ^ string_of_float diff)

let rec repeats (n: int) (f: 'a -> 'a) (input: 'a) : 'a =
  if n < 0 then raise (Invalid_argument "n should be positive!")
  else if n = 0 then input
  else repeats (n - 1) f (f input)

module Position = struct
  type t = int * int

  let compare ((p1x, p1y): t) ((p2x, p2y): t) : int =
    let c = compare p1x p2x in
    if c = 0 then compare p1y p2y else c

  let to_string (x, y: t) : string = string_of_int x ^ " " ^ string_of_int y

end

module PosMap = struct
  include Map.Make (Position)

  (* prepare for future extension *)
end

module IntMap = Map.Make (struct
    type t = int
    let compare i1 i2 = Pervasives.compare i1 i2
  end)

module HashSet = struct
  type 'a t = ('a, unit) Hashtbl.t

  let create () : 'a t = Hashtbl.create ~random:true 16

  let clear : 'a t -> unit = Hashtbl.reset

  let add (i: 'a) (set: 'a t) : unit = Hashtbl.replace set i ()

  let elem (set: 'a t) : 'a list = Hashtbl.fold (fun i () lst -> i::lst) set []
end
