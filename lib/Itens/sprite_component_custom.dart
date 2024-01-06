import 'dart:async';

import 'package:ancient_game/Components/scanner_effect.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SpriteComponentCustom extends SpriteComponent
{

  SpriteComponentCustom({required super.position, required super.size, required super.sprite});
  late final ScannerEffect scannerEffect;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    scannerEffect = ScannerEffect(size)..scanSpeed = size.y;
    add(scannerEffect);
  }

  @override
  render(Canvas canvas) {
    scannerEffect.render(canvas);
    super.render(canvas);
  }
    


}