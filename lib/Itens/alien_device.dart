import 'dart:async';

import 'package:ancient_game/ancient_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum AnimationStates{idle, scan}

class AlienDevice extends SpriteAnimationGroupComponent with HasGameRef<AncientGame>
{
  AlienDevice({required super.position, required super.size});
  late TextComponent message;

  Vector2 textureSize = Vector2(65, 52);
  SpriteAnimation _addAnimation(animacao, amount, stepTime)
  {
    
    final data = SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: stepTime,
      textureSize: textureSize,
    );
    String path = 'sprites/$animacao-device-Sheet.png';
  
    final animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(path), data);
    return animation;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    priority = 31;

    animations = 
    {
      AnimationStates.idle: _addAnimation('idle', 3, 0.2),
      AnimationStates.scan: _addAnimation('scanning', 4, 0.2),
    };
    current = AnimationStates.idle;
    Color color = const Color(0xffffffff).withAlpha(100);
    message = TextComponent(anchor: Anchor.center,position: Vector2(size.x/2 + 0.8   , size.y/2-1.5), text: '' ,textRenderer: TextPaint(style: TextStyle(
        fontFamily: 'alien',
        fontSize: 6,
        color: color
    ))); 
    add(message);
  }

  void setMessage(String text){
    message.text = text;
  }

  void setCoords(Vector2 coords){
    Vector2 realCords = Vector2((coords.x/game.blockSize).floorToDouble(), (coords.y/game.blockSize).floorToDouble());
    message.text = '${realCords.x.toInt()} ${realCords.y.toInt()}';
  }

  void scan(){
    current = AnimationStates.scan;
    int time = (0.2*4*1000).round();
    message.text = '';
    Future.delayed(Duration(milliseconds: time), (){
      current = AnimationStates.idle;
    });
  }
  
}