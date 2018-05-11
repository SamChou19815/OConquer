open OUnit
open User

(** [float_pair_equal p1 p2] compares whether two float pairs are equal. *)
let float_pair_equal (p1: float * float) (p2: float * float) : unit =
  let printer (r1, r2) =
    string_of_float r1 ^ " " ^ string_of_float r2
  in
  let round f = (f +. 0.5) |> floor |> int_of_float in
  let comparator (r1, r2) (r1ref, r2ref) =
    let r1 = round r1 in
    let r2 = round r2 in
    let r1ref = round r1ref in
    let r2ref = round r2ref in
    r1 = r1ref && r2 = r2ref
  in
  assert_equal ~cmp:comparator ~printer:printer p1 p2

(** [two_users] gives two users from a dummy database. *)
let two_users : user * user =
  let open Database in
  match register "Sam" "1" empty with
  | None -> failwith "Bad! Cannot register Sam!"
  | Some (db, sam_token) ->
    match register "San" "2" db with
    | None -> failwith "Bad! Cannot register San!"
    | Some (db, san_token) ->
      match get_user_opt_by_token sam_token db,
            get_user_opt_by_token san_token db
      with
      | Some u1, Some u2 -> (u1, u2)
      | _ -> failwith "Bad! Token Missing!"

let tests = [
  (** Tests for [Elo] sub-module. *)
  "user_elo_test1" >:: (fun () ->
      let prev_rating = (100., 100.) in
      let curr_rating = Elo.update_rating 0.5 prev_rating in
      float_pair_equal (100., 100.) curr_rating
    );
  "user_elo_test2" >:: (fun () ->
      let prev_rating = (200., 100.) in
      let curr_rating = Elo.update_rating 0.5 prev_rating in
      float_pair_equal (204., 96.) curr_rating
    );
  "user_elo_test3" >:: (fun () ->
      let prev_rating = (100., 200.) in
      let curr_rating = Elo.update_rating 0.5 prev_rating in
      float_pair_equal (96., 204.) curr_rating
    );
  "user_elo_test4" >:: (fun () ->
      let prev_rating = (100., 100.) in
      let curr_rating = Elo.update_rating 1. prev_rating in
      float_pair_equal (115., 85.) curr_rating
    );
  "user_elo_test5" >:: (fun () ->
      let prev_rating = (200., 100.) in
      let curr_rating = Elo.update_rating 1. prev_rating in
      float_pair_equal (219., 81.) curr_rating
    );
  "user_elo_test6" >:: (fun () ->
      let prev_rating = (100., 200.) in
      let curr_rating = Elo.update_rating 1. prev_rating in
      float_pair_equal (111., 189.) curr_rating
    );
  "user_elo_test7" >:: (fun () ->
      let prev_rating = (100., 100.) in
      let curr_rating = Elo.update_rating 0. prev_rating in
      float_pair_equal (85., 115.) curr_rating
    );
  "user_elo_test8" >:: (fun () ->
      let prev_rating = (200., 100.) in
      let curr_rating = Elo.update_rating 0. prev_rating in
      float_pair_equal (189., 111.) curr_rating
    );
  "user_elo_test9" >:: (fun () ->
      let prev_rating = (100., 200.) in
      let curr_rating = Elo.update_rating 0. prev_rating in
      float_pair_equal (81., 219.) curr_rating
    );

  (** Tests for [Database] sub-module. *)
  "user_db_test1" >:: (fun () ->
      assert_equal None Database.(empty |> sign_in "" "")
    );
  "user_db_test2" >:: (fun () ->
      assert_equal false Database.(empty |> has_token 1)
    );
  "user_db_test3" >:: (fun () ->
      assert_equal None Database.(empty |> get_user_opt_by_token 1)
    );
  "user_db_test4" >:: (fun () ->
      let open Database in
      match register "Sam" "1" empty with
      | None -> failwith "Bad! Cannot register Sam!"
      | Some (db, token) ->
        (* Test register and sign in functionality. *)
        let () = assert_equal None (register "Sam" "2" db) in
        let () = assert_equal None (sign_in "Sam" "2" db) in
        let () = assert_equal (Some token) (sign_in "Sam" "1" db) in
        match register "Anonymous" "2" db with
        | None -> failwith "Bad! Cannot register Anonymous!"
        | Some (db, token2) ->
          let () =
            assert_bool "Missing Sam's Token" (has_token token db)
          in
          let () =
            assert_bool "Missing Anonymous's Token" (has_token token2 db)
          in
          (* Test score board *)
          let open Yojson.Basic in
          let expected_score_board: json =
            `List [
              `Assoc [
                "username", `String "Sam";
                "rating", `Float 100.
              ];
              `Assoc [
                "username", `String "Anonymous";
                "rating", `Float 100.
              ]
            ]
          in
          (* Make order of list irrelevant *)
          let comparator (j1: json) (j2: json) : bool =
            let c (l1: (string * json) list) (l2: (string * json) list) : int =
              let to_string l = l |> List.assoc "username" |> Util.to_string in
              String.compare (to_string l1) (to_string l2)
            in
            let p (j: json) : (string * json) list list =
              j |> Util.to_list |> List.map Util.to_assoc |> List.sort c
            in
            p j1 = p j2
          in
          assert_equal ~cmp:comparator expected_score_board (score_board db)
    );

  (** Tests for the [MatchMaking] sub-module. *)
  "user_matchmaking_test" >:: (fun () ->
      let (sam, san) = two_users in
      let open MatchMaking in
      let player_sam = create_player sam "" "" in
      let player_san = create_player san "" "" in
      match accept_and_form_match player_sam empty_queue with
      | Some _, _ -> failwith "Should not be able to form match!"
      | None, queue ->
        match accept_and_form_match player_san queue with
        | None, _ -> failwith "Should be able to form match!"
        | Some (p1, p2), queue ->
          let () = assert_equal player_sam p1 in
          let () = assert_equal player_san p2 in
          let () = assert_equal sam (get_user_from_player p1) in
          let () = assert_equal san (get_user_from_player p2) in
          assert_equal empty_queue queue
    );
]
