
import 'dart:async';

import 'package:ancient_game/Components/audio_controller.dart';
import 'package:ancient_game/Itens/alien_computer.dart';
import 'package:ancient_game/Itens/alien_device.dart';
import 'package:ancient_game/Itens/alien_device_pickable.dart';
import 'package:ancient_game/Itens/alien_keyboard.dart';
import 'package:ancient_game/Itens/door.dart';
import 'package:ancient_game/Itens/readable.dart';
import 'package:ancient_game/Itens/scannable_item.dart';
import 'package:ancient_game/Player/animation.dart';
import 'package:ancient_game/Player/indicator_arrow.dart';
import 'package:ancient_game/ancient_game.dart';
import 'package:ancient_game/Components/input_manager.dart';

import 'package:flame/extensions.dart';
import 'package:flame/geometry.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Player extends BodyComponent<AncientGame>{

  
  Vector2 pos; Vector2 size = Vector2(14, 17);
  Player({required this.pos});

  final double moveSpeed = 100;
  final double jumpSpeed = 350;

  late InputManager inputManager;
  late AudioController audioController;
  late PlayerAnimationAssets animation;
  late IndicatorArrow arrow;

  late  Offset rayOrigin;
  late  Offset rayDirection;
  final double rayDistance = 15;

  final int waitTimeMilliseconds = 1000;
  late final AlienDevice alienDevice;
  bool hasAlienDevice = false;

  final AlienKeyboard alienKeyboard = AlienKeyboard();
  final WritingClue writingClue = WritingClue();

  bool isScanning = false;
  Vector2? wallPos;
  dynamic lastObject;


  @ override
  Future<void> onLoad() async{
    priority = 20;
    debugMode = false;
    await super.onLoad();
    inputManager = InputManager.instance;
    animation = PlayerAnimationAssets(position: Vector2(0, -4));
    add(animation);
    rayOrigin = const Offset(0, -4);
    rayDirection = const Offset(1, 0);
    game.cam.follow(this);

    alienDevice = AlienDevice(
      position: Vector2(-game.blockSize*game.width/4 +7, game.blockSize*game.height/8 +8),
      size: Vector2(32, 32),
    );

    arrow = IndicatorArrow(playerSize: size);
    add(arrow);
    audioController = AudioController.instance;
    audioController.addPlayer('longScan', 'longScan.wav',  loop: true, volume: 0.5);
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

    final shape = PolygonShape()..setAsBoxXY(size.x/2, (size.y/2)*0.5);
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
    if(alienKeyboard.isActive) 
    {
      if(alienKeyboard.password.isNotEmpty)
      {
        final rigths = game.checkAnswer(alienKeyboard.password);
        if(rigths == 5) {
          game.openDoor();
          audioController.play('Correct.wav');
        }
        else{
          audioController.play('Wrong.wav');
        }
        
        alienKeyboard.message.text = '$rigths / 5';
        alienKeyboard.password = '';
      }
      if(inputManager.commands[Command.exitComputer]!)
      {
        alienKeyboard.isActive = false;
        alienKeyboard.password = '';
        remove(alienKeyboard);
      }
      return;
    }
    else if(writingClue.isActive)
    {
      if(inputManager.commands[Command.exitComputer]!)
      {
        writingClue.isActive = false;
        remove(writingClue);
      }
      return;
    }  
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
    rayOrigin = const Offset(0, -4);

    //arrow on direction of the movement
    
  }


  void _raycast() {
    if(body.linearVelocity.x != 0 || body.linearVelocity.y != 0) rayDirection = Offset(body.linearVelocity.x, body.linearVelocity.y);
      rayDirection = rayDirection / rayDirection.distance;
    
    arrow.direction = rayDirection.toVector2();
    final Ray2 ray = Ray2(origin:Vector2(position.x, position.y -4), direction:Vector2(rayDirection.dx, rayDirection.dy));
    final result = game.collisionDetection.raycast(ray, maxDistance:rayDistance);

    if(result != null && (result.hitbox?.parent?.parent is Readable || result.hitbox?.parent?.parent is AlienComputer)){
      wallPos = result.intersectionPoint! + rayDirection.toVector2()*(game.blockSize/264);
    }

    if(result != null && result.hitbox?.parent?.parent is AlienDevicePickable){
      lastObject = result.hitbox?.parent?.parent as AlienDevicePickable;
      wallPos = result.intersectionPoint! + rayDirection.toVector2()*(game.blockSize/264);
    }
    else if(result != null && result.hitbox?.parent?.parent is ScannableItem)
    {
      lastObject = result.hitbox?.parent?.parent as ScannableItem;
      if(hasAlienDevice)
      {
        lastObject.scan = true;
        audioController.resume('longScan');   
      }
    }
    else if(result != null && result.hitbox?.parent?.parent is Door)
    {
      if(result.distance! < 9)
      {
        print('Over');
      }
      audioController.pause('longScan');
    }
    else{
      lastObject = null;
      wallPos = null;
      audioController.pause('longScan');
    }
  }




  void _useItem(){
    if(inputManager.commands[Command.showText]!){
      inputManager.commands[Command.showText] = false;
      if(isScanning) return;
      
      if(lastObject is ScannableItem && hasAlienDevice) {
        final String text = lastObject!.description;
        isScanning = true;
        alienDevice.scan();
        audioController.play('scan.wav');
        Future.delayed(Duration(milliseconds: (0.2*4*1000).round()), () => {
          isScanning = false,
          alienDevice.setMessage(text)
        });

      }
    }
    else if(inputManager.commands[Command.openComputer]!)
    {
      if(lastObject is AlienDevicePickable) {
        hasAlienDevice = true;
        add(alienDevice);
        lastObject.pick();
        lastObject = null;
      }
      else if(lastObject is AlienComputer) 
      {
        add(alienKeyboard);
        alienKeyboard.isActive = true;
        lastObject = null;
      }
      else if(lastObject is Readable)
      {
        add(writingClue);
        writingClue.isActive = true;
        lastObject = null;
      }
    }

   
  }

}