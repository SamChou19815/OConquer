test:
	ocamlbuild -use-ocamlfind engine.byte

compile:
	ocamlbuild -use-ocamlfind engine.cmo

zip:
	zip submission.zip *.ml* ./sample_sdk/* _tags Makefile

clean:
	ocamlbuild -clean
	rm -f submission.zip
