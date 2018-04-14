open Cohttp

(** [accepted_method] is all possible accepted methods for this app. *)
type accepted_method = GET | POST

(** [params] is the type of all the parameter map. *)
type params = (string * string list) list

(**
 * [convenient_handler] handlers a request according to parameters with type
 * [param], body in [string] and give a response.
 * For example, if [h] is a [convenient_handler], then [h params body] means
 * [h] will handle the request with parameters in [param] and body in [body].
 * It is a high level concept and it can be used to produce a low level
 * [handler].
 * When writing a convenient handler, there is no need to convert an unexpected
 * error into string to match the type. Just throw the exception and this
 * module will handle it for you.
*)
type convenient_handler = params -> string -> string

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
 * - [h] is a high level convenient handler. It is allowed to throw exception
 *   to indicate a very bad client request.
 * Returns: a constructed corresponding low level handler.
*)
val create_handler : accepted_method -> string -> convenient_handler -> handler

(**
 * [test_handler] is a trivial handler that handles GET request at /test which
 * just prints ["It works!"]. It is used as a quick start.
 * As an example, this handler is created by the following code:
 * [create_handler GET "/test" (fun _ b -> "It works!")]
*)
val test_handler : handler

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
