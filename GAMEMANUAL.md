# CS 3110 Final Project - OConquer GAME MANUAL

# System Requirement
- java JDK
- OCaml
- npm
- node.js

# Background

Inspired by the Heart of Iron series and Red Alert Series, OConquer is a sandbox military strategy simulation game developed in OCaml, where players control military units by writing their own driving programs in Java and feeding the code to the game. The military units will execute their programs sequentially; driving program with better strategy embedded would lead the military units to conquer the world and claim victory.

# Goal

The essential strategy to win the game is to carefully plan on military unit's actions under different situations.

# How to Play

## Actions
- Attack
- Divide
- Turn Left
- Turn Right

## Write Your Program

### Introduction

Instead of controlling your military unit by specifying command at each round,
you write a Java program to control them automatically. You are almost free to
use any Java 8 features, which some restrictions described below. We provided
some APIs for you to interact with the world.

### Requirement for your program

We have provided you a template for your program, which can be seen at
`/programs/src/BlackProgram.java` and `/programs/src/WhiteProgram.java`.

When submitting your program, you only need to submit these two files.

In these two files, we used comments to mark some boundary lines. For example,

```
/*
 * ******************************************
 * DO NOT EDIT ABOVE THIS LINE.
 * ******************************************
 */
```

Please respect these comments' instruction, or your code will not compile when
submitted to our server.

Also, your code should not make use of `System.in` and `System.out`, because
they would interfere with our interactive IO API.

You can use any classes in Java's standard library. External libraries are not
supported.

### Our API

We implemented all the low level IO between your Java program and our game
server. You do not need to worry about those details. We defined some Java data
classes for you, and our API will return these data classes instead of raw
strings.

The SDK functions are available via the `SDK` object passed to the constructor
of your program classes. You can see `GameSDK.java` for more details.
