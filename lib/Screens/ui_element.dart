import 'dart:async';


import 'package:ancient_game/ancient_game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';


class UIButton extends PositionComponent with TapCallbacks, HasGameRef<AncientGame>{

  final String label;
  final Function onTap;
  final double fontSize;
  final Color? color;
  UIButton({this.fontSize = 10, this.color,  required this.label, required this.onTap, required super.position, required super.size}): super(anchor: Anchor.center);
  
  @override
  FutureOr<void> onLoad() async{
      // debugMode = true;
      anchor = Anchor.center;
      TextPaint renderer = TextPaint(style: TextStyle(
        fontFamily: 'joystix monospace', fontSize: fontSize,
        color: color?? const Color(0xFF819796)
      ));
    addAll([
        TextComponent(
          size:size,
          text: label,
          textRenderer: renderer,
        )
    ]);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap.call();
  }
}

class UITextElement extends TextComponent
{
  UITextElement({required Vector2 position, required String text, required double size, required Color color, Anchor anchor = Anchor.center})
  {
    TextPaint renderer = TextPaint(style: TextStyle(
      fontFamily: 'joystix monospace', fontSize: size,
    color: color
    ));

    this.position = position;
    this.text = text;
    this.anchor = anchor;
    textRenderer = renderer;
  }
}