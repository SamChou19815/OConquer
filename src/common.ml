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

(** [Int] is the integer adapter module for [Map]. *)
module Int = struct
  type t = int
  let compare = Pervasives.compare
end

module PosMap = Map.Make (Position)

module IntMap = Map.Make (Int)

module StringMap = Map.Make (String)

module HashSet = struct
  type 'a t = ('a, unit) Hashtbl.t

  let make () : 'a t = Hashtbl.create ~random:true 16

  let clear : 'a t -> unit = Hashtbl.reset

  let add (i: 'a) (set: 'a t) : unit = Hashtbl.replace set i ()

  let elem (set: 'a t) : 'a list = Hashtbl.fold (fun i () lst -> i::lst) set []
end

module ArrayList = struct

  (** ['a t] remembers both the content and actual size. *)
  type 'a t = {
    mutable actual_size: int;
    mutable content: 'a array;
  }

  let make (template: 'a) : 'a t =
    { actual_size = 0; content = Array.make 16 template }

  let size (l: 'a t) : int = l.actual_size

  let get (i: int) (l: 'a t) : 'a =
    if i >= 0 && i < l.actual_size then l.content.(i)
    else invalid_arg "index out of bounds"

  let add (v: 'a) (l: 'a t) : unit =
    let () =
      if l.actual_size == Array.length l.content then begin
        let old_len = Array.length l.content in
        let new_content = Array.make (old_len * 2) l.content.(0) in
        for i = 0 to (old_len - 1) do
          (* copy over to the new one *)
          new_content.(i) <- l.content.(i)
        done;
        l.content <- new_content
      end
      else ()
    in
    let () = l.content.(l.actual_size) <- v in
    l.actual_size <- l.actual_size + 1

  let sub (s: int) (t: int) (l: 'a t) : 'a list =
    if s < 0 then invalid_arg "index out of bounds"
    else
      let rec builder i acc =
        if i < s then acc
        else builder (i - 1) (get i l::acc)
      in
      builder (t - 1) []

end
