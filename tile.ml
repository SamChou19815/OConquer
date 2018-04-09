type t = Empty | Mountain | Fort | City of int

let to_string : t -> string = function
  | Empty -> "TILE EMPTY"
  | Mountain -> "TILE MOUNTAIN"
  | Fort -> "TILE FORT"
  | City level -> "TILE CITY " ^ string_of_int level
