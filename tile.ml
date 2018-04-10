type t = Empty | Mountain | Fort | City of int

exception NotUpgradable

let upgrade_tile : t -> t = function
  | Mountain -> raise NotUpgradable
  | Empty -> Fort
  | Fort -> City 1
  | City i -> City (i + 1)

let to_string : t -> string = function
  | Empty -> "TILE EMPTY"
  | Mountain -> "TILE MOUNTAIN"
  | Fort -> "TILE FORT"
  | City level -> "TILE CITY " ^ string_of_int level
