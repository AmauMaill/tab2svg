(**
   Main parser module that combines lexer and parser functionality.
   @author Your Name
   @version 1.0
*)

module T = Tab_types
module L = Lexer

type parse_error =
  | Invalid_token_sequence
  | Missing_string_name
  | Mismatched_line_lengths
  | Empty_tab

(** Convert tokens to a tab position *)
let rec parse_position tokens =
  match tokens with
  | [] -> (Empty, [])
  | L.Bar :: rest -> (Bar_line, rest)
  | L.Separator :: rest -> (Empty, rest)
  | L.Number n :: L.Technique t :: rest ->
      (Note { fret = Some n; technique = Some t }, rest)
  | L.Number n :: rest ->
      (Note { fret = Some n; technique = None }, rest)
  | _ :: rest -> parse_position rest

(** Parse a sequence of tokens into a tab line *)
let parse_line tokens =
  let rec parse_positions acc = function
    | [] | [L.EOL] -> List.rev acc
    | tokens ->
        let (pos, rest) = parse_position tokens in
        parse_positions (pos :: acc) rest
  in
  match tokens with
  | L.StringName c :: rest ->
      Ok { string_name = c; positions = parse_positions [] rest }
  | _ -> Error Missing_string_name

(** [parse_tab input] parses a complete guitar tablature
    @param input The input string containing the complete tab
    @return Parsed tab structure
*)
let parse_tab (input : string) : (T.tab, parse_error) result =
  let lines = String.split_on_char '\n' input in
  let tokenized_lines = List.map L.tokenize_line lines in
  
  let parse_results = List.map parse_line tokenized_lines in
  match parse_results with
  | [] -> Error Empty_tab
  | results ->
      let (parsed_lines, errors) = List.partition_map
        (function Ok l -> Left l | Error e -> Right e)
        results
      in
      if List.length errors > 0 then
        Error Invalid_token_sequence
      else
        let line_lengths =
          List.map (fun line -> List.length line.positions) parsed_lines
        in
        if List.sort_uniq compare line_lengths |> List.length > 1 then
          Error Mismatched_line_lengths
        else
          Ok { lines = parsed_lines }

let%test "parse_minimal_tab" =
  match parse_tab "e|---0---|" with
  | Ok result ->
      List.length result.lines = 1 &&
      (List.hd result.lines).string_name = 'e'
  | Error _ -> false

let%test "parse_with_technique" =
  match parse_tab "G|--5h7--|" with
  | Ok result ->
      let line = List.hd result.lines in
      line.string_name = 'G' &&
      match List.nth line.positions 2 with
      | Note { fret = Some 5; technique = Some Hammer_on } -> true
      | _ -> false
  | Error _ -> false