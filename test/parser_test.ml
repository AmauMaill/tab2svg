open Alcotest
open Parser.Types

let test_simple_note () =
  let note = { fret = 0; technique = None } in
  check int "same fret" 0 note.fret;
  check (option technique) "no technique" None note.technique

let technique = testable
  (fun ppf t -> Format.fprintf ppf "%s"
    (match t with
     | Slide_up -> "slide_up"
     | Slide_down -> "slide_down"
     | Hammer_on -> "hammer_on"
     | Pull_off -> "pull_off"
     | Bend -> "bend"))
  (=)

let test_set = [
  "simple note", `Quick, test_simple_note;
]

let () =
  run "Parser Tests" [
    "notes", test_set;
  ]
