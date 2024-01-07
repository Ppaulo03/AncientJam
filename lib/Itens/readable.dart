import 'dart:async';

import 'package:ancient_game/Itens/scannable_item.dart';
import 'package:ancient_game/Itens/sprite_component_custom.dart';
import 'package:ancient_game/ancient_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
class Readable extends ScannableItem
{
  Readable({required super.pos});

  @override
  Future<void> onLoad() {
    description = 'ab';
    final image = game.images.fromCache('sprites/objects/book.png');
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

}

class WritingClue extends SpriteComponent with HasGameRef<AncientGame>{
  late TextComponent message;
  bool isActive = false;

  @override
  FutureOr<void> onLoad() {
    priority = 100;
    size = Vector2(64, 16);
    message = TextComponent(size: size, position: Vector2(0, 0), text: '' ,textRenderer: TextPaint(style: const TextStyle(
        fontFamily: 'joystix monospace',
        fontSize: 4,
        color: Color(0xffc7cfcc)
    )));
    add(message);

    final ExitKey exitKey = ExitKey(key: 'X', position:Vector2(0, -15), size: Vector2(16, 16));
    exitKey.onStateChange = exit;
    add(exitKey);

    sprite = Sprite(game.images.fromCache('sprites/alien-computer-input.png'));
    position = Vector2(-20, -20);
    
    return super.onLoad();
  }

  void exit()
  {
    parent?.remove(this);
    isActive = false;
  }
}

class ExitKey extends SpriteComponent with TapCallbacks, HasGameRef<AncientGame>
{
  late final Function onStateChange;
  final String key;
  ExitKey({required this.key, required super.position, required super.size});
  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async{
    debugMode = false;
    sprite = Sprite(game.images.fromCache('sprites/button-keyboard.png'));
    super.onLoad();
    add(TextComponent(position: Vector2(size.x/8, size.y/8), text: key, textRenderer: TextPaint(style: const TextStyle(
        fontFamily: 'joystix monospace',
        fontSize: 3.75,
        color: Color(0xffc7cfcc)
    ))));
    hitbox = RectangleHitbox();
    add(hitbox);
    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onStateChange.call();
  }
}