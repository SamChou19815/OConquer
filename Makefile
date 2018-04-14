main:
	ocamlbuild -use-ocamlfind main.byte

test:
	ocamlbuild -use-ocamlfind main.byte

zip:
	zip submission.zip *.ml* ./sample_sdk/* _tags Makefile

clean:
	ocamlbuild -clean
	rm -f submission.zip
