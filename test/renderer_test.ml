open Tab2svg_types.Tab
open Tab2svg_svg.Renderer
open Alcotest

let sample_tab = {
  lines = [
    { string_name = 'e';
      positions = [
        Bar_line;
        Empty;
        Note { fret = Some 0; technique = None };
        Empty;
        Bar_line;
      ]
    };
    { string_name = 'B';
      positions = [
        Bar_line;
        Empty;
        Note { fret = Some 1; technique = Some Hammer_on };
        Empty;
        Bar_line;
      ]
    }
  ]
}

(* Helper function to check if a string contains a substring *)
let contains s1 s2 =
  let re = Str.regexp_string s2 in
  try ignore (Str.search_forward re s1 0); true
  with Not_found -> false

let test_basic_svg () =
  let svg = tab_to_svg sample_tab () in
  check bool "contains SVG header" true (contains svg "<?xml");
  check bool "contains SVG tag" true (contains svg "<svg");
  check bool "contains viewBox" true (contains svg "viewBox")

let test_note_rendering () =
  let svg = tab_to_svg sample_tab () in
  check bool "contains fret number 0" true (contains svg ">0<");
  check bool "contains fret number 1" true (contains svg ">1<")

let test_technique_rendering () =
  let svg = tab_to_svg sample_tab () in
  check bool "contains path for hammer-on" true (contains svg "<path")

let test_string_labels () =
  let svg = tab_to_svg sample_tab () in
  check bool "contains string name e" true (contains svg ">e<");
  check bool "contains string name B" true (contains svg ">B<")

let tests = [
  test_case "basic svg generation" `Quick test_basic_svg;
  test_case "note rendering" `Quick test_note_rendering;
  test_case "technique rendering" `Quick test_technique_rendering;
  test_case "string labels" `Quick test_string_labels;
]