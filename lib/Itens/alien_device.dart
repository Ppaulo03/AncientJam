import 'dart:async';

import 'package:ancient_game/ancient_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class AlienDevice extends SpriteComponent with HasGameRef<AncientGame>
{
  AlienDevice({required super.position, required super.size});
  late TextComponent message;


  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    priority = 31;
    sprite = Sprite(game.images.fromCache('sprites/player_sprite.png'));
    message = TextComponent(position: Vector2(0, size.y/4), text: '' ,textRenderer: TextPaint(style: const TextStyle(
        fontFamily: 'joystix monospace',
        fontSize: 5,
        color: Color(0xffc7cfcc)
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
  
}