(**
   Core types for guitar tab representation.
   @author Your Name
   @version 1.0
*)

(** Technique represents guitar playing techniques *)
type technique =
  | Slide_up     (** / *)
  | Slide_down   (** \ *)
  | Hammer_on    (** h *)
  | Pull_off     (** p *)
  | Bend         (** b *)

(** Represents a single note in the tab *)
type note = {
  fret: int option;       (** Fret number (None represents empty position) *)
  technique: technique option;  (** Optional playing technique *)
}

(** Tab position represents a single position in the tablature *)
type tab_position =
  | Empty      (** No note played *)
  | Note of note  (** A note at this position *)
  | Bar_line   (** Vertical bar line *)

(** Tab line represents one string's worth of tab positions *)
type tab_line = {
  string_name: char;  (** String name (e, B, G, D, A, E) *)
  positions: tab_position list;  (** List of positions in the line *)
}

(** Complete tab representation *)
type tab = {
  lines: tab_line list;  (** List of tab lines, one per string *)
}

(** Creates an empty tab position *)
let empty_position = Empty

(** Creates a bar line position *)
let bar_line = Bar_line

(** Creates a note position *)
let create_note fret technique = Note { fret; technique }