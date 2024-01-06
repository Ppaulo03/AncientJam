import 'package:ancient_game/Itens/scannable_item.dart';
import 'package:ancient_game/Itens/sprite_component_custom.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class AlienDevicePickable extends ScannableItem{
 
  AlienDevicePickable({required super.pos});

  @override
  Future<void> onLoad() {
    final image = game.images.fromCache('sprites/player_sprite.png');
    sprite = SpriteComponentCustom(sprite: Sprite(image), position: Vector2(-size.x/2, -size.y/2), size: size);
    return super.onLoad();
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
      ..type = BodyType.static
      ..fixedRotation = true
      ..gravityScale = Vector2(0, 0);
      
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void pick(){
    parent?.remove(this);
  }

}