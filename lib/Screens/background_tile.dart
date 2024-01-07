import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';



class BackgroundTile extends ParallaxComponent{

  final double speed;
  final String imagePath;
  Vector2 pos = Vector2.zero();
  BackgroundTile( {this.imagePath = 'background.png', this.speed = 25, pos});

  @override
  FutureOr<void> onLoad() async {
    priority = -10;
    size = Vector2.all(64);
    position = pos;
    
    parallax = await game.loadParallax(
      [ParallaxImageData(imagePath)],
      baseVelocity: Vector2(-speed, speed),
      repeat: ImageRepeat.repeat,
      fill: LayerFill.none,
      
    );
    return super.onLoad();
  }
}
