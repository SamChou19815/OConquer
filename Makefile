main:
	ocamlbuild -use-ocamlfind main.byte

test:
	ocamlbuild -use-ocamlfind main.byte

testprogramrunner:
	ocamlbuild -use-ocamlfind program_runner_test.byte && \
	./program_runner_test.byte

docs:
	mkdir -p docs
	ocamldoc -html -d docs/ -colorize-code -short-functors -stars -keep-code \
	-I ~/.opam/4.06.0/lib/cohttp/ -I ~/.opam/4.06.0/lib/ocaml/ \
	-I ~/.opam/4.06.0/lib/yojson/ -I _build/ \
	*.ml[i]

cleandocs:
	rm -rf ./docs

zip:
	zip submission.zip *.ml* ./sample_sdk/* _tags Makefile

clean:
	ocamlbuild -clean
	rm -f submission.zip
	rm -rf ./docs
