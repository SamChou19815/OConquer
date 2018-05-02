open Common

module Base = struct
  type user = {
    username: string;
    password: string;
    token: int
  }
end

module Database = struct
  (** [t] should always been synced between [token_map] and [username_map]. *)
  type t = {
    token_map: Base.user IntMap.t;
    username_map: Base.user StringMap.t;
  }

  let empty : t = { token_map = IntMap.empty; username_map = StringMap.empty; }

  let register (username: string) (password: string) (db: t) : t * int option =
    db, None

  let sign_in (username: string) (password: string) (db: t) : int option = None

  let has_token (token: int) (db: t) : bool = false
end
