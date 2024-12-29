open Types

(** Token type for lexical analysis *)
type token =
  | Number of int
  | Separator
  | Bar
  | Technique of technique
  | StringName of char
  | EOL

let tokenize_line line =
  (* TODO: Implement tokenization *)
  []

let%test "tokenize_simple_line" =
  let input = "e|---0---1---|" in
  let expected = [
    StringName 'e';
    Bar;
    Separator; Separator; Separator;
    Number 0;
    Separator; Separator; Separator;
    Number 1;
    Separator; Separator; Separator;
    Bar;
  ] in
  tokenize_line input = expected
