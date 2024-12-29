open Tab2svg_types.Tab
open Tab2svg_parser.Parser
open Alcotest

let test_parse_simple_tab () =
  let tab_str = "e|---0---1---|\nB|---1---0---|" in
  match parse_tab tab_str with
  | Ok tab -> 
      check int "number of lines" 2 (List.length tab.lines);
      let first_line = List.hd tab.lines in
      check char "first string name" 'e' first_line.string_name
  | Error _ -> 
      fail "Failed to parse valid tab"

let test_invalid_tab () =
  let tab_str = "e|----|\nB|------|" in
  match parse_tab tab_str with
  | Ok _ -> fail "Should fail with mismatched line lengths"
  | Error Mismatched_line_lengths -> ()
  | Error _ -> fail "Wrong error type"

let tests = [
  test_case "simple tab" `Quick test_parse_simple_tab;
  test_case "invalid tab" `Quick test_invalid_tab;
]