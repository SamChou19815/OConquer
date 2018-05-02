open Common

type user = {
  username: string;
  password: string;
  token: int
}

module Database = struct
  (** [t] should always been synced between [token_map] and [username_map]. *)
  type t = {
    token_map: user IntMap.t;
    username_map: user StringMap.t;
  }

  let empty : t = { token_map = IntMap.empty; username_map = StringMap.empty; }

  let register (username: string) (password: string)
      (db: t) : (t * int) option =
    if StringMap.mem username db.username_map then None
    else
      begin
        Random.self_init ();
        let rec find_non_conflicting_token () =
          let random_token = Random.int max_int in
          if IntMap.mem random_token db.token_map then
            find_non_conflicting_token ()
          else random_token
        in
        let token = find_non_conflicting_token () in
        let user = { username; password; token } in
        let db' = {
          token_map = IntMap.add token user db.token_map;
          username_map = StringMap.add username user db.username_map;
        } in
        Some (db', token)
      end

  let sign_in (username: string) (password: string) (db: t) : int option =
    match StringMap.find_opt username db.username_map with
    | None -> None
    | Some user -> Some user.token

  let has_token (token: int) (db: t) : bool = IntMap.mem token db.token_map
end
