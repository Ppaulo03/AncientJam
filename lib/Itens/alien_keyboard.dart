import 'dart:async';

import 'package:ancient_game/ancient_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

enum Key {a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, escape}
double keyD = 8;
double keyOX = 0;
double keyOY = 30;

class AlienKeyboard extends SpriteComponent with HasGameRef<AncientGame>
{
  
  final Map<Key, AlienKeyboardKey> keyMap = {
    Key.a: AlienKeyboardKey(key: 'a', position: Vector2(keyOX, keyOY),           size: Vector2(keyD, keyD)),
    Key.b: AlienKeyboardKey(key: 'b', position: Vector2(keyOX + keyD, keyOY),    size: Vector2(keyD, keyD)),
    Key.c: AlienKeyboardKey(key: 'c', position: Vector2(keyOX + keyD*2, keyOY),  size: Vector2(keyD, keyD)),
    Key.d: AlienKeyboardKey(key: 'd', position: Vector2(keyOX + keyD*3, keyOY),  size: Vector2(keyD, keyD)),
    Key.e: AlienKeyboardKey(key: 'e', position: Vector2(keyOX + keyD*4, keyOY),  size: Vector2(keyD, keyD)),
    Key.f: AlienKeyboardKey(key: 'f', position: Vector2(keyOX + keyD*5, keyOY),  size: Vector2(keyD, keyD)),
    Key.g: AlienKeyboardKey(key: 'g', position: Vector2(keyOX + keyD*6, keyOY),  size: Vector2(keyD, keyD)),
    Key.h: AlienKeyboardKey(key: 'h', position: Vector2(keyOX + keyD*7, keyOY),  size: Vector2(keyD, keyD)),
    Key.i: AlienKeyboardKey(key: 'i', position: Vector2(keyOX + keyD*8, keyOY),  size: Vector2(keyD, keyD)),
    Key.j: AlienKeyboardKey(key: 'j', position: Vector2(keyOX + keyD, keyOY + keyD),  size: Vector2(keyD, keyD)),
    Key.k: AlienKeyboardKey(key: 'k', position: Vector2(keyOX + keyD*2, keyOY + keyD), size: Vector2(keyD, keyD)),
    Key.l: AlienKeyboardKey(key: 'l', position: Vector2(keyOX + keyD*3, keyOY + keyD), size: Vector2(keyD, keyD)),
    Key.m: AlienKeyboardKey(key: 'm', position: Vector2(keyOX + keyD*4, keyOY + keyD), size: Vector2(keyD, keyD)),
    Key.n: AlienKeyboardKey(key: 'n', position: Vector2(keyOX + keyD*5, keyOY + keyD), size: Vector2(keyD, keyD)),
    Key.o: AlienKeyboardKey(key: 'o', position: Vector2(keyOX + keyD*6, keyOY + keyD), size: Vector2(keyD, keyD)),
    Key.p: AlienKeyboardKey(key: 'p', position: Vector2(keyOX + keyD*7, keyOY + keyD), size: Vector2(keyD, keyD)),
    Key.q: AlienKeyboardKey(key: 'q', position: Vector2(keyOX + keyD*8, keyOY + keyD), size: Vector2(keyD, keyD)),
    Key.r: AlienKeyboardKey(key: 'r', position: Vector2(keyOX + keyD*2, keyOY + keyD*2), size: Vector2(keyD, keyD)),
    Key.s: AlienKeyboardKey(key: 's', position: Vector2(keyOX + keyD*3, keyOY + keyD*2), size: Vector2(keyD, keyD)),
    Key.t: AlienKeyboardKey(key: 't', position: Vector2(keyOX + keyD*4, keyOY + keyD*2), size: Vector2(keyD, keyD)),
    Key.u: AlienKeyboardKey(key: 'u', position: Vector2(keyOX + keyD*5, keyOY + keyD*2), size: Vector2(keyD, keyD)),
    Key.v: AlienKeyboardKey(key: 'v', position: Vector2(keyOX + keyD*6, keyOY + keyD*2), size: Vector2(keyD, keyD)),
    Key.escape: AlienKeyboardKey(key: 'ESC', position: Vector2(keyOX, -keyOY/2 ), size: Vector2(keyD, keyD)),
  };

  late TextComponent message;
  bool isActive = false;
  String password = '';

  @override
  FutureOr<void> onLoad() {
    priority = 100;
    for (final key in keyMap.values) {
      key.onStateChange = addKey;
      add(key);
    }

    message = TextComponent(position: Vector2(0, 0), text: '' ,textRenderer: TextPaint(style: const TextStyle(
        fontFamily: 'alien',
        fontSize: 4,
        color: Color(0xffc7cfcc)
    )));
    add(message);

    sprite = Sprite(game.images.fromCache('sprites/player_sprite.png'));
    position = Vector2(-20, -20);
    size = Vector2(64, 16);
    return super.onLoad();
  }

  void addKey(String key){
    if(key == 'ESC'){
      message.text = '';
      isActive = false;
      parent?.remove(this);
      return;
    } 

    message.text += key;
    if(message.text.length > 5){
      password = message.text;
      message.text = '';
      isActive = false;
      parent?.remove(this);
    }
  }

}

class AlienKeyboardKey extends SpriteComponent with TapCallbacks, HasGameRef<AncientGame>
{
  late final Function onStateChange;
  final String key;
  AlienKeyboardKey({required this.key, required super.position, required super.size});
  late ShapeHitbox hitbox;

  @override
  Future<void> onLoad() async{
    debugMode = false;
    sprite = Sprite(game.images.fromCache('sprites/player_sprite.png'));
    super.onLoad();
    add(TextComponent(position: Vector2(0, 0), text: key, textRenderer: TextPaint(style: const TextStyle(
        fontFamily: 'alien',
        fontSize: 3.75,
        color: Color(0xffc7cfcc)
    ))));
    hitbox = RectangleHitbox();
    add(hitbox);
    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    onStateChange.call(key);
  }
}