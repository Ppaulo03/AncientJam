

import 'package:ancient_game/Itens/collider_item.dart';
import 'package:ancient_game/Itens/sprite_component_custom.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:ancient_game/ancient_game.dart';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';


class HieroglifoPillar extends BodyComponent<AncientGame>{
  Vector2 pos; Vector2 size = Vector2(16, 16);
  HieroglifoPillar({required this.pos});

  String description = 'vs';
  bool lastState = false;
  bool scan = false;
  late SpriteComponentCustom sprite;

  @override
  Future<void> onLoad() {
    final image = game.images.fromCache('sprites/player_sprite.png');
    sprite = SpriteComponentCustom(sprite: Sprite(image), position: Vector2(-size.x/2, -size.y/2), size: size);
    add(sprite);
    add(ColliderItem(position: pos, size: size));

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

    @override
  void update(double dt) {
    super.update(dt);
    if(scan != lastState){
      lastState = scan;
      if(scan){
        sprite.scannerEffect.scan = true;
      }
      else{
        sprite.scannerEffect.isScanning = false;
      }
    }
    scan = false;
  }
  
}