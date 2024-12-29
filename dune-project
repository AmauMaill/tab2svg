(lang dune 3.12)
(name tab2svg)

(generate_opam_files true)
(source (github username/tab2svg))
(authors "Your Name")
(maintainers "Your Name")
(license MIT)

(package
 (name tab2svg)
 (synopsis "ASCII guitar tab to SVG converter")
 (description "A command-line tool that converts guitar ASCII tablatures to SVG format for better visualization and sharing")
 (depends
  (ocaml (>= 5.1.1))
  (dune (>= 3.12))
  (core (>= v0.16.1))
  xmlm
  (alcotest :with-test)
  (ppx_inline_test :with-test)
  (odoc :with-doc)))

(formatting
 (enabled_for ocaml))