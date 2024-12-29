(** SVG representation types *)

type point = {
  x: float;
  y: float;
}

type line = {
  start_point: point;
  end_point: point;
  stroke_width: float;
  stroke_color: string;
}

type text = {
  content: string;
  position: point;
  font_size: float;
  font_family: string;
}

type svg_element =
  | Line of line
  | Text of text

type svg = {
  width: float;
  height: float;
  elements: svg_element list;
}
