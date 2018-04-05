type identifier = string

type var_type = IntType | BoolType | ObjectType of identifier

type unary_operator = NOT | NEGATION

type binary_operator =
  | LT | GT | LE | GE | EQ | NEQ (* Comparison *)
  | Plus | Minus | Mul | Div | Mod (* Int operation *)
  | AND | OR (* Bool operation *)
  | InstanceOf (* Type operation *)

type expr =
  | UnaryOperation of unary_operator * expr
  | BinaryOperation of expr * binary_operator * expr
  | FieldAccess of expr * identifier
  | MethodCall of expr * identifier * (expr list)
  | Int of int
  | Bool of bool
  | New of identifier
  | Identifier of identifier
  | This

type statement =
  | Block of statement list
  | If of expr * statement * statement
  | While of expr * statement
  | Assignment of identifier * expr
  | NewVar of var_type * expr
  | Break
  | Continue

type method_decl = {
  return_type: var_type;
  name: identifier;
  arguments: (var_type * identifier) list;
  code: statement list;
  return_expr: expr; (* Only last expression can be return expr *)
}

type class_member_decl =
  | MethodDecl of method_decl | FieldDecl of var_type * identifier * expr
  | ClassDecl of class_decl
and class_decl = {
  class_name: identifier;
  class_members: class_member_decl list
}

type program = class_decl
