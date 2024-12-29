open Tab2svg_test

let () =
  Alcotest.run "Tab2svg" [
    "Lexer", Lexer_test.tests;
    "Parser", Parser_test.tests;
    "Renderer", Renderer_test.tests;
  ]