# CS 3110 Final Project

## System Requirement

- Java JDK 8
- OCaml
- npm
- node.js

## How to play with the code

Ensure you have all the Ocaml packages in _tags.

Then `make` will compile all the ocaml code, `make test` will run all the
existing tests, `make clean` will clean the build.

We also provided some other functionality for Makefile. Running `make docs` can
generate Ocaml docs in `/docs` in you are on Mac. Running `make cleandocs` will
clear the docs. You need to clear the docs first if you want to regenerate docs.

## How to run the game in local mode

You should first compile all the your code as described above.

Firstly, start Local Server: `./main.byte local`. You should see
`Server started at http://localhost:8080` printed to the console.

Secondly, start Frontend Server:

```shell
cd web-app
npm install # this may take a while
npm run start
```

Then you can visit `http://localhost:4200` to start playing the game.

This procedule will be simplified in the future.

## How to start the server in distributed mode

You should first compile all the your code as described above.

Firstly, start Local Server: `./main.byte remote`. You should see
`Server started at http://localhost:8088` printed to the console.

Right now, remote server is still under developement.

## Game Description

Read the [Game Manual](https://github.com/SamChou19815/CS3110-Final-Project/blob/master/MANUAL.md)
for more information.
