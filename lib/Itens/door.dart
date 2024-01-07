

import 'package:ancient_game/Itens/collider_item.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:ancient_game/ancient_game.dart';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';


class Door extends BodyComponent<AncientGame>{
  Vector2 pos; Vector2 size = Vector2(16, 16);
  Door({required this.pos});
  late final SpriteGroupComponent sprites;

  @override
  Future<void> onLoad() {
    final open = game.images.fromCache('sprites/objects/door.png');
    final closed = game.images.fromCache('sprites/objects/door-opened.png');

    sprites = SpriteGroupComponent();
    sprites.anchor = Anchor.center;
    sprites.sprites = {
      'closed': Sprite(open, srcSize: Vector2(16, 16), srcPosition: Vector2(0, 0)),
      'open': Sprite(closed, srcSize: Vector2(16, 16), srcPosition: Vector2(0, 0)),
    };
    sprites.current = 'closed';
    add(sprites);
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

  void open(){
    sprites.current = 'open';
    //disable body collision
    add(ColliderItem(position: pos, size: size));
  } 
  
}