# CS 3110 Final Project

## System Requirement

- Java JDK 8
- OCaml
- npm
- node.js

## How to play with the code

Ensure you have all the Ocaml packages in _tags and all the system requirement
described above.

Then `make` will compile all the ocaml code, `make test` will run all the
existing tests, `make clean` will clean the build.

Run `make build` will build the entire app to make it production ready. If you
just want to play with it, definitely run this command.

We also provided some other functionality for Makefile. Running `make docs` can
generate Ocaml docs in `/docs` in you are on Mac. Running `make cleandocs` will
clear the docs. You need to clear the docs first if you want to regenerate docs.

## How to run the game in local mode

You should first compile all the your code as described above.

Firstly, start Local Server: `./main.byte local`. You should see
`Server started at http://localhost:8080` printed to the console.

Then you can visit `http://localhost:8080` to start playing the game.

## How to start the server in distributed mode

You should first compile all the your code as described above.

Firstly, start Local Server: `./main.byte remote`. You should see
`Server started at http://localhost:8088` printed to the console.

There is no GUI for remote server. You just setup the remote server as a
competition platform for others. If you want others to use your remote server,
simply tell them your IP address.

## Game Description

Read the [Game Manual](https://github.com/SamChou19815/CS3110-Final-Project/blob/master/MANUAL.md)
for more information.
