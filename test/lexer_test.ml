open Tab2svg_types.Tab
open Tab2svg_parser.Lexer
open Alcotest

let token_testable = Alcotest.testable
  (fun fmt token ->
    match token with
    | StringName c -> Format.fprintf fmt "StringName %c" c
    | Bar -> Format.fprintf fmt "Bar"
    | Separator -> Format.fprintf fmt "Separator"
    | Number n -> Format.fprintf fmt "Number %d" n
    | Technique t -> Format.fprintf fmt "Technique %s" 
        (match t with
         | Slide_up -> "Slide_up"
         | Slide_down -> "Slide_down"
         | Hammer_on -> "Hammer_on"
         | Pull_off -> "Pull_off"
         | Bend -> "Bend")
    | EOL -> Format.fprintf fmt "EOL")
  (=)

let test_simple_line () =
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
  check (list token_testable) "simple line" expected (tokenize_line input)

let test_technique_line () =
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
  check (list token_testable) "technique line" expected (tokenize_line input)

let tests = [
  test_case "simple line" `Quick test_simple_line;
  test_case "technique line" `Quick test_technique_line;
]