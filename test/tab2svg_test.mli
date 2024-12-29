(** Test suite for Tab2svg *)

module Lexer_test : sig
    val tests : unit Alcotest.test_case list
  end
  
  module Parser_test : sig
    val tests : unit Alcotest.test_case list
  end
  
  module Renderer_test : sig
    val tests : unit Alcotest.test_case list
  end