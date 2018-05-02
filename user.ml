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



end
