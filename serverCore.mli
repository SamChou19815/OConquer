open Cohttp

(** [accepted_method] is all possible accepted methods for this app. *)
type accepted_method = GET | POST

(** [params] is the type of all the parameter map. *)
type params = (string * string list) list

(** [response] is the type of the response given to the client. *)
type response = (Response.t * Cohttp_lwt__Body.t) Lwt.t

(**
 * [convenient_handler] handlers a request according to parameters with type
 * [param], body in [string] and give a response.
 * It is a high level concept and it can be used to produce a low level
 * [handler].
*)
type convenient_handler = params -> string -> response

(**
 * [handler] is an abstract type that handle the requests in a low level way.
 * It can choose to accept or reject an request and write data streams.
 * This handler can not be directly produced; instead, user should create this
 * handler indirectly via a [convenient_handler].
*)
type handler

(**
 * [create_handler m path h] produces a low level handler from the prescribed
 * accepted method [m] and accepted path [path] to accept or reject a request.
 * Then it transforms a convenient handler [h] to a fully fledged handler.
 *
 * Requires:
 * - [m] is [GET] or [POST].
 * - [path] is a legal path that starts with "/" but does not end with "/".
 * - [h] is a high level convenient handler.
 * Returns: a constructed corresponding low level handler.
*)
val create_handler : accepted_method -> string -> convenient_handler -> handler

(**
 * [start_server handlers] starts a new server with its serving behavior defined
 * by the [handlers]. If [port] is unspecified, it defaults to 8080.
 *
 * Requires: If given, [port] must be a valid port. It should not require root
 * access.
 * Returns: None.
 * Effect: A server with all the given [handlers] has been started at
 * http://localhost:8080.
*)
val start_server : ?port:int -> handler list -> unit
