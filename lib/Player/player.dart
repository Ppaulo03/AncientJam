
import 'dart:async';

import 'package:ancient_game/Itens/alien_computer.dart';
import 'package:ancient_game/Itens/alien_device.dart';
import 'package:ancient_game/Itens/alien_keyboard.dart';
import 'package:ancient_game/Itens/scannable_item.dart';
import 'package:ancient_game/Player/animation.dart';
import 'package:ancient_game/ancient_game.dart';
import 'package:ancient_game/Components/input_manager.dart';

import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';


class Player extends BodyComponent<AncientGame>{

  
  Vector2 pos; Vector2 size = Vector2(15, 25);
  Player({required this.pos});

  final double moveSpeed = 100;
  final double jumpSpeed = 350;

  late InputManager inputManager;
  late PlayerAnimationAssets animation;
  late  Offset rayOrigin;
  late  Offset rayDirection;
  final double rayDistance = 25;
  final int waitTimeMilliseconds = 1000;
  late final AlienDevice alienDevice;
  final AlienKeyboard alienKeyboard = AlienKeyboard();


  bool isScanning = false;
  Vector2? wallPos;
  dynamic lastObject;


  @ override
  Future<void> onLoad() async{
    priority = 20;
    debugMode = false;
    await super.onLoad();
    inputManager = InputManager.instance;
    animation = PlayerAnimationAssets();
    add(animation);
    rayOrigin = const Offset(0, 0);
    rayDirection = const Offset(1, 0);
    game.cam.follow(this);

    alienDevice = AlienDevice(
      position: Vector2(-game.blockSize*game.width/4, game.blockSize*game.height/8),
      size: Vector2(16, 16),
    );
    add(alienDevice);
  }

  @override
  render (Canvas canvas){
    super.render(canvas);
    if(renderBody){
      canvas.drawLine(rayOrigin, rayOrigin + rayDirection * rayDistance, paint);
    }
    if(wallPos != null){
      //Blocks of 16x16 get the block on wallPos
      final Vector2 blockPos = Vector2( 
          (wallPos!.x/game.blockSize).floorToDouble()*game.blockSize - position.x,
          (wallPos!.y/game.blockSize).floorToDouble()*game.blockSize - position.y
              );
      canvas.drawRect(Rect.fromLTWH(blockPos.x, blockPos.y, 16, 16), Paint() ..color = Colors.red ..style = PaintingStyle.stroke);
    }

    
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
    if(alienKeyboard.isActive) return;
    _move(dt);
    _raycast();
    _useItem();
    
  }

  void _move(double dt){
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
    rayOrigin = const Offset(0, 0);
  }


  void _raycast(){
    if(body.linearVelocity.x != 0 || body.linearVelocity.y != 0) rayDirection = Offset(body.linearVelocity.x, body.linearVelocity.y);
      rayDirection = rayDirection / rayDirection.distance;
    
    final Ray2 ray = Ray2(origin:position, direction:Vector2(rayDirection.dx, rayDirection.dy));
    final result = game.collisionDetection.raycast(ray, maxDistance:rayDistance);
    
    if(result != null && result.hitbox?.parent is RectangleComponent){
      lastObject = null;
      wallPos = result.intersectionPoint! + rayDirection.toVector2()*(game.blockSize/2);
    }
    else if(result != null && result.hitbox?.parent?.parent is ScannableItem)
    {
      lastObject = result.hitbox?.parent?.parent as ScannableItem;
      lastObject.scan = true;
    }

    else{
      lastObject = null;
      wallPos = null;
    }
  }


  void _useItem(){
    if(inputManager.commands[Command.showText]!){
      inputManager.commands[Command.showText] = false;
      if(isScanning) return;
      print(lastObject);
      if(lastObject is ScannableItem) 
      {
        final String text = lastObject!.description;
        isScanning = true;
        Future.delayed(Duration(milliseconds: waitTimeMilliseconds), () => {
          isScanning = false,
          alienDevice.setMessage(text)
        });

      }
    }
    else if(inputManager.commands[Command.showCoordenates]!)
    {
      if(lastObject is AlienComputer) 
      {
        add(alienKeyboard);
        alienKeyboard.isActive = true;
      }
    }

   
  }

}