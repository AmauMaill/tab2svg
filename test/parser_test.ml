(**
   Test suite for the tab parser
   @author Your Name
   @version 1.0
*)

open Alcotest
open Parser.Types

let technique = Alcotest.testable
  (fun fmt t ->
    match t with
    | Slide_up -> Format.fprintf fmt "Slide_up"
    | Slide_down -> Format.fprintf fmt "Slide_down"
    | Hammer_on -> Format.fprintf fmt "Hammer_on"
    | Pull_off -> Format.fprintf fmt "Pull_off"
    | Bend -> Format.fprintf fmt "Bend")
  (=)

let tab_position = Alcotest.testable
  (fun fmt pos ->
    match pos with
    | Empty -> Format.fprintf fmt "Empty"
    | Bar_line -> Format.fprintf fmt "Bar"
    | Note n -> 
        match n.fret, n.technique with
        | None, None -> Format.fprintf fmt "Note(Empty)"
        | Some f, None -> Format.fprintf fmt "Note(%d)" f
        | Some f, Some t -> Format.fprintf fmt "Note(%d with technique)" f
        | None, Some t -> Format.fprintf fmt "Note(Empty with technique)")
  (=)

let test_empty_position () =
  check tab_position "empty position" Empty empty_position

let test_bar_line () =
  check tab_position "bar line" Bar_line bar_line

let test_simple_note () =
  let note_pos = create_note (Some 5) None in
  check tab_position "fret 5" (Note { fret = Some 5; technique = None }) note_pos

let test_note_with_technique () =
  let note_pos = create_note (Some 7) (Some Hammer_on) in
  check tab_position "fret 7 with hammer-on" 
    (Note { fret = Some 7; technique = Some Hammer_on }) note_pos

let test_tab_line () =
  let line = {
    string_name = 'e';
    positions = [empty_position; bar_line; create_note (Some 5) None]
  } in
  check char "string name" 'e' line.string_name;
  check (list tab_position) "positions" 
    [Empty; Bar_line; Note { fret = Some 5; technique = None }]
    line.positions

let () =
  run "Parser Tests" [
    "positions", [
      test_case "empty position" `Quick test_empty_position;
      test_case "bar line" `Quick test_bar_line;
      test_case "simple note" `Quick test_simple_note;
      test_case "note with technique" `Quick test_note_with_technique;
    ];
    "tab_line", [
      test_case "basic tab line" `Quick test_tab_line;
    ];
  ]