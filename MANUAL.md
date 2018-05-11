# CS 3110 Final Project - OConquer Manual

## Background

Inspired by the Heart of Iron series and Red Alert Series, OConquer is a sandbox
military strategy simulation game developed in OCaml, where players control
military units by writing their own driving programs in Java and feeding the
code to the game. The military units will execute their programs sequentially;
driving program with better strategy embedded would lead the military units to
conquer the world and claim victory.

## Goal

The essential strategy to win the game is to carefully plan on military unit's
actions under different situations.

## How to Play

You play the game by submitting a program that control your military unit.
If the programs compile, then the game will start.

The game runs in discrete rounds on a `map_width` times `map_height` world map.
In each round, we will sequentially execute all the programs of all the existing
military unit in the world map to decide their action, then we execute their
action. The new produced military unit in this round will also execute their
program.

The game ends when one sides completely wipes the other side from the map, or
when the game round reached `max_turns`, and we count the number of occupied
territory to declare the winner (which may be a draw).

Besides the program control, if your military unit is in a city, then its number
of soldiers will increase by city level times `increase_soldier_factor`.

In each round, the program should decide the action of itself, which is one
of the followings:

### Action Descriptions and Specification

#### Do Nothing

You literally do nothing. Nothing changes.

#### Attack

The attack works as follows:

Firstly, if there is nothing to be attacked or the military unit in the front
is on the same side as your military unit, then it will end by doing nothing.

If attack can happen, then the attacker will first increase its morale by
`attack_morale_change` and then inflict some damage on the attacked. The
attacked may be completely eliminated in this stage, then the attacker will not
incur any damage on itself.

If the attacked survived, its morale will drop by `attack_morale_change`. Then
it will launch a retaliation attack on the attacker, which may wipes the
attacker from the map.

The damage can be calculated as follows:

```
raw_damage = base_attack_damage * logistic(attacker's number of soldiers
                * attacker's morale * attacker's leadership)
if the attacked is in a city or fort, its damage will be reduced by a factor of
        fort_city_bonus_factor
```

#### Train

Training your military unit will increase its fighting capability. It will
increase the morale of the military unit by `training_morale_boost` and its
leadership by `training_leadership_boost`. This action always succeeds.

#### Turn Left

Your military unit will now turn left. This action always succeeds.

#### Turn Right

Your military unit will now turn right. This action always succeeds.

#### Move Forward

Your military unit will now move forward by unit. This action will succeed iff
there is no other military unit or mountain in front of you. If it fails,
nothing happens.

#### Retreat Backward

Your military unit will first turn back. Turning back always succeeds. Then it
will move forward as defined above. This action will incur morale and leadership
penalty, which are `retreat_morale_penalty` and `retreat_leadership_penalty`,
so be careful.

#### Divide

It will split the military unit into two with equal morale and leadership, each
with half of the original soldiers. The new one will be placed in front of the
old military unit. If the military unit trying to split's front has a mountain
or another military unit, the action will fail and nothing happens.

#### Upgrade

The military will upgrade the tile it is currently on. An empty tile will be
upgraded to fort. A fort will be upgraded to a city of level 1. A city will
increase its value directly. This action always succeeds.

### Write Your Program

#### Introduction

Instead of controlling your military unit by specifying command at each round,
you write a Java program to control them automatically. You are almost free to
use any Java 8 features, which some restrictions described below. We provided
some APIs for you to interact with the world.

#### Requirement for your program

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

#### Our API

We implemented all the low level IO between your Java program and our game
server. You do not need to worry about those details. We defined some Java data
classes for you, and our API will return these data classes instead of raw
strings.

The SDK functions are available via the `SDK` object passed to the constructor
of your program classes. You can see `GameSDK.java` for more details.

## Constants of Game

```ocaml
let map_width = 10

let map_height = 10

let max_turns = 500

let training_morale_boost = 1

let training_leadership_boost = 1

let retreat_morale_penalty = 1

let retreat_leadership_penalty = 1

let increase_soldier_factor = 0.5

let base_attack_damage = 5

let fort_city_bonus_factor = 1.5

let attack_morale_change = 1
```
