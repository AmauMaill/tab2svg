(**
   SVG renderer for guitar tablature
   @author Your Name
   @version 1.0
*)

open Tab2svg_types.Tab

(** SVG layout configuration *)
type layout_config = {
  string_spacing: float;      (** Vertical spacing between strings *)
  position_width: float;      (** Horizontal width for each position *)
  margin: float;             (** Margin around the tab *)
  font_size: float;          (** Font size for numbers *)
  line_stroke_width: float;  (** Width of tab lines *)
}

(** Default layout configuration *)
let default_config = {
  string_spacing = 20.0;
  position_width = 30.0;
  margin = 40.0;
  font_size = 14.0;
  line_stroke_width = 1.0;
}

(** Generate SVG path for a technique symbol *)
let technique_to_path technique x y =
  match technique with
  | Hammer_on -> Printf.sprintf "M %f %f a 5 5 0 0 1 10 0" x y  (* Small arc *)
  | Pull_off -> Printf.sprintf "M %f %f a 5 5 0 0 0 10 0" x y   (* Inverted arc *)
  | Slide_up -> Printf.sprintf "M %f %f l 10 -10" x y           (* Upward line *)
  | Slide_down -> Printf.sprintf "M %f %f l 10 10" x y          (* Downward line *)
  | Bend -> Printf.sprintf "M %f %f c 5 -10 5 -10 10 -10" x y   (* Curve up *)

(** Generate SVG for a single tab position *)
let position_to_svg pos x y config =
  match pos with
  | Empty -> ""  (* Nothing to render for empty position *)
  | Bar_line ->
      Printf.sprintf
        "<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" \
         stroke=\"black\" stroke-width=\"%f\"/>"
        x (y -. config.string_spacing *. 2.5)
        x (y +. config.string_spacing *. 2.5)
        config.line_stroke_width
  | Note { fret = Some f; technique = t } ->
      let number = Printf.sprintf
        "<text x=\"%f\" y=\"%f\" \
         font-family=\"monospace\" \
         font-size=\"%f\" \
         text-anchor=\"middle\">%d</text>"
        x (y +. config.font_size /. 3.0)
        config.font_size
        f
      in
      let technique_path = match t with
        | Some tech -> 
            Printf.sprintf
              "<path d=\"%s\" stroke=\"black\" fill=\"none\"/>"
              (technique_to_path tech (x +. 5.0) y)
        | None -> ""
      in
      number ^ technique_path
  | Note { fret = None; technique = _ } -> ""  (* Skip empty notes *)

(** Generate SVG for a complete tab line *)
let line_to_svg line y_pos config =
  let string_label = Printf.sprintf
    "<text x=\"%f\" y=\"%f\" \
     font-family=\"monospace\" \
     font-size=\"%f\">%c</text>"
    (config.margin -. 20.0)
    (y_pos +. config.font_size /. 3.0)
    config.font_size
    line.string_name
  in
  (* Horizontal line *)
  let tab_line = Printf.sprintf
    "<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" \
     stroke=\"black\" stroke-width=\"%f\"/>"
    config.margin
    y_pos
    (config.margin +. (float_of_int (List.length line.positions)) *. config.position_width)
    y_pos
    config.line_stroke_width
  in
  (* Generate each position *)
  let positions = 
    List.mapi
      (fun i pos ->
         let x = config.margin +. (float_of_int i) *. config.position_width in
         position_to_svg pos x y_pos config)
      line.positions
  in
  string_label :: tab_line :: positions
  |> String.concat "\n"

(** Generate complete SVG for a tab *)
let tab_to_svg tab ?(config = default_config) () =
  let height = 
    (float_of_int (List.length tab.lines + 1)) *. config.string_spacing +. 
    config.margin *. 2.0 
  in
  let max_positions = 
    List.fold_left
      (fun max line -> Int.max max (List.length line.positions))
      0 tab.lines 
  in
  let width = 
    config.margin *. 2.0 +. 
    (float_of_int max_positions) *. config.position_width 
  in
  let header = Printf.sprintf
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
     <svg xmlns=\"http://www.w3.org/2000/svg\" \
          width=\"%f\" height=\"%f\" \
          viewBox=\"0 0 %f %f\">"
    width height width height
  in
  let content =
    List.mapi
      (fun i line ->
         let y_pos = config.margin +. (float_of_int i) *. config.string_spacing in
         line_to_svg line y_pos config)
      tab.lines
    |> String.concat "\n"
  in
  header ^ "\n" ^ content ^ "\n</svg>"