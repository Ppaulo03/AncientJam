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
    description = 'em';
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

class WritingClue extends PositionComponent with HasGameRef<AncientGame>{
  late TextComponent message;
  late TextComponent messageLine2;
  late TextComponent messageLine3;
  bool isActive = false;

  @override
  FutureOr<void> onLoad() {
    priority = 100;
    size = Vector2(64, 16);
    message = TextComponent(size: size, position: Vector2(0, -10), text: 'The only way out is using the device.' ,textRenderer: TextPaint(style: const TextStyle(
        fontFamily: 'joystixmonospace',
        fontSize: 4,
        color: Color(0xffc7cfcc)
    )));
      messageLine2 = TextComponent(size: size, position: Vector2(0, -4), text: 'the password of the door is:' ,textRenderer: TextPaint(style: const TextStyle(
        fontFamily: 'joystixmonospace',
        fontSize: 4,
        color: Color(0xffc7cfcc)
    )));
      messageLine3 = TextComponent(size: size, position: Vector2(0,2), text: 'knowledge - poison - sledgeHammer  - coffin - gem' ,textRenderer: TextPaint(style: const TextStyle(
        fontFamily: 'joystixmonospace',
        fontSize: 4,
        color: Color(0xffc7cfcc)
    )));
      var messageLine4 = TextComponent(size: size, position: Vector2(9, -16), text: 'to exit' ,textRenderer: TextPaint(style: const TextStyle(
        fontFamily: 'joystixmonospace',
        fontSize: 2,
        color: Color(0xffc7cfcc)
    )));
    addAll([message,messageLine2,messageLine3,messageLine4]);

    final ExitKey exitKey = ExitKey(key: 'Esc', position:Vector2(0, -20), size: Vector2(8, 8),fontSize: 2.5);
    exitKey.onStateChange = exit;
    add(exitKey);
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
  double? fontSize;
  ExitKey({required this.key, this.fontSize, required super.position, required super.size });
  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async{
    debugMode = false;
    sprite = Sprite(game.images.fromCache('sprites/button-keyboard.png'));
    super.onLoad();
    add(TextComponent(position: Vector2(size.x/8, size.y/8), text: key, textRenderer: TextPaint(style:  TextStyle(
        fontFamily: 'joystixmonospace',
        fontSize:fontSize ?? 3.75,
        color: const Color(0xffc7cfcc)
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