test:
	ocamlbuild -use-ocamlfind engine.byte

compile:
	ocamlbuild -use-ocamlfind engine.cmo

clean:
	ocamlbuild -clean
