(** Core types for tab representation *)

(** Represents a single note or technique on a string *)
type technique =
  | Slide_up
  | Slide_down
  | Hammer_on
  | Pull_off
  | Bend

(** Represents a fret position with optional technique *)
type note = {
  fret: int;
  technique: technique option;
}

(** Represents a single position in the tab (empty or with note) *)
type tab_position =
  | Empty
  | Note of note
  | Bar_line

(** Represents a single line of tab for one string *)
type tab_line = {
  string_name: char;
  positions: tab_position list;
}

(** Represents a complete tab with all strings *)
type tab = {
  lines: tab_line list;
}
