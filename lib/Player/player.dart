
import 'dart:async';


import 'package:ancient_game/Player/animation.dart';
import 'package:ancient_game/ancient_game.dart';
import 'package:ancient_game/Components/input_manager.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';


class Player extends BodyComponent<AncientGame>{

  
  Vector2 pos; Vector2 size = Vector2(15, 25);
  Player({required this.pos});

  final double moveSpeed = 100;
  final double jumpSpeed = 350;

  late InputManager inputManager;
  late PlayerAnimationAssets animation;
  

  @ override
  Future<void> onLoad() async{
    await super.onLoad();
    inputManager = InputManager.instance;
    animation = PlayerAnimationAssets();
    add(animation);
  }

  @override
  Body createBody() {
    renderBody = game.debug;
    paint =  Paint()
      ..color = const Color.fromARGB(255, 1, 241, 53)
      ..style = PaintingStyle.stroke;

    final shape = PolygonShape()..setAsBoxXY(size.x/2, size.y/2);
    final fixtureDef = FixtureDef(shape);
    final bodyDef = BodyDef()
      ..position = Vector2(pos.x + size.x/2, pos.y + size.y/2)
      ..type = BodyType.dynamic
      ..fixedRotation = true
      ..gravityScale = Vector2(0, 0);
      
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    super.update(dt);
    double horizontalMovement = 0;
    if(inputManager.commands[Command.moveLeft]!){
      horizontalMovement -= 1;
      animation.isFacingLeft = true;
    }
    if(inputManager.commands[Command.moveRight]!){
      horizontalMovement += 1;
      animation.isFacingLeft = false;
    }

    double verticalMovement = 0;
    if(inputManager.commands[Command.moveUp]!){
      verticalMovement -= 1;
    }
    if(inputManager.commands[Command.moveDown]!){
      verticalMovement += 1;
    }

    if(horizontalMovement != 0 && verticalMovement != 0){
      horizontalMovement *= 0.7;
      verticalMovement *= 0.7;
    }

    body.linearVelocity = Vector2(horizontalMovement * moveSpeed, verticalMovement * moveSpeed);
    animation.setAnimation(body.linearVelocity);
    
  }

}