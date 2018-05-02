(**
 * [ServerKernels] contains a collection of server kernels to be used in Main.
*)

(** [LocalServerKernel] is the kernel of local server. *)
module LocalServerKernel : LocalServer.Kernel

(** [RemoteServerKernel] is the kernel of the remote server.  *)
module RemoteServerKernel : RemoteServer.Kernel
