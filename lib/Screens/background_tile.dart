import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';



class BackgroundTile extends ParallaxComponent{

  final double speed;
  final String imagePath;
  Vector2 pos = Vector2.zero();
  BackgroundTile( {this.imagePath = 'sprites/menu-paralalax.png', this.speed = 5, pos});

  @override
  FutureOr<void> onLoad() async {
    priority = -10;
    size = Vector2(0,0);
    position = pos;
    
    parallax = await game.loadParallax(
      [ParallaxImageData(imagePath)],
      baseVelocity: Vector2(0, speed),
      size: size,  
      repeat: ImageRepeat.repeat,
      fill: LayerFill.height,
      filterQuality: FilterQuality.none
    );
    return super.onLoad();
  }
}
