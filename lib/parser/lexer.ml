(**
   Lexer module for guitar tab parsing.
   Handles tokenization of ASCII tab input.
   @author Your Name
   @version 1.0
*)

open Tab_types

(** Token represents the different elements in a tab line *)
type token =
  | Number of int     (** Fret number *)
  | Separator         (** Dash between notes *)
  | Bar              (** Vertical bar line *)
  | Technique of technique  (** Playing technique *)
  | StringName of char  (** String identifier *)
  | EOL               (** End of line *)

(** Convert a character to a technique option *)
let char_to_technique = function
  | '/' -> Some Slide_up
  | '\\' -> Some Slide_down
  | 'h' -> Some Hammer_on
  | 'p' -> Some Pull_off
  | 'b' -> Some Bend
  | _ -> None

(** Convert a character to a string name option *)
let char_to_string_name = function
  | 'e' | 'B' | 'G' | 'D' | 'A' | 'E' as c -> Some c
  | _ -> None

(** [tokenize_line line] converts a string of ASCII tab into tokens
    @param line The input string representing one line of ASCII tab
    @return List of tokens representing the tab line
*)
let tokenize_line (line : string) : token list =
  let rec tokenize_chars = function
    | [] -> []
    | c :: rest ->
        match c with
        | '-' -> Separator :: tokenize_chars rest
        | '|' -> Bar :: tokenize_chars rest
        | c when char_to_string_name c <> None ->
            StringName c :: tokenize_chars rest
        | '0'..'9' as c ->
            Number (int_of_char c - int_of_char '0') :: tokenize_chars rest
        | c when char_to_technique c <> None ->
            Technique (Option.get (char_to_technique c)) :: tokenize_chars rest
        | '\n' -> EOL :: tokenize_chars rest
        | ' ' | '\t' -> tokenize_chars rest  (* Skip whitespace *)
        | _ -> tokenize_chars rest  (* Skip invalid characters *)
  in
  line |> String.to_seq |> List.of_seq |> tokenize_chars

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

let%test "tokenize_technique_line" =
  let input = "G|--5h7-----|" in
  let expected = [
    StringName 'G';
    Bar;
    Separator; Separator;
    Number 5;
    Technique Hammer_on;
    Number 7;
    Separator; Separator; Separator; Separator; Separator;
    Bar;
  ] in
  tokenize_line input = expected