main:
	ocamlbuild -use-ocamlfind main.byte

test:
	ocamlbuild -use-ocamlfind main.byte

docs:
	mkdir -p docs
	ocamldoc -html -d docs/ -colorize-code -short-functors -intf definitions.ml -intf gameConstants.ml *.ml[i]

cleandocs:
	rm -rf ./docs

zip:
	zip submission.zip *.ml* ./sample_sdk/* _tags Makefile

clean:
	ocamlbuild -clean
	rm -f submission.zip
	rm -rf ./docs
