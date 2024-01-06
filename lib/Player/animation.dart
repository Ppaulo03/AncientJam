import 'dart:async';
import 'dart:ui';

import 'package:ancient_game/Components/scanner_effect.dart';
import 'package:ancient_game/ancient_game.dart';
import 'package:flame/components.dart';

enum PlayerState {

  idle,
  running,
  jumping,
  falling,
}

class PlayerAnimationAssets extends SpriteAnimationGroupComponent with HasGameRef<AncientGame>{

  final double stepTime;
  final Vector2 textureSize = Vector2(16, 25);
  PlayerAnimationAssets({super.position, this.stepTime = 0.1});
  
  final ScannerEffect scannerEffect = ScannerEffect(Vector2(16, 25));
  

  SpriteAnimation _addAnimation(animacao, left, amount)
  {
    
    final data = SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: stepTime,
      textureSize: textureSize,
    );
    String path = 'sprites/player/cake-alice-$animacao';
    path += left ? '-left' : '-right';
    path += '-sprite-sheet.png';

    final animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(path), data);

    add(scannerEffect);

    return animation;
  }


  @override
  void render(Canvas canvas) {
    scannerEffect.render(canvas);
    super.render(canvas);
  }

  @override
  FutureOr<void> onLoad(){
    //Travel position from center to top left of itself
    position = Vector2(position.x - textureSize.x/2, position.y - textureSize.y/2);

    priority = 31;
    debugMode = game.debug;
    size = Vector2(16, 25);
    animations = {
      PlayerState.idle: _addAnimation('idle', false, 1),
      PlayerState.running: _addAnimation('running', false, 4),
      PlayerState.jumping: _addAnimation('jumping', false, 1),
      PlayerState.falling: _addAnimation('falling', false, 1),
    };
    current = PlayerState.idle;
  }

  bool _isFacingLeft = false;

  bool get isFacingLeft => _isFacingLeft;
  set isFacingLeft(bool value){
    if(value != isFacingLeft){
      _isFacingLeft = value;
      flipHorizontallyAroundCenter();
    }
  }

  void setAnimation(Vector2 velocity){
    PlayerState newAnimation = PlayerState.idle;
    if(velocity.x != 0 || velocity.y != 0 ){
      newAnimation = PlayerState.running;
    }
    if(current != newAnimation){
      current = newAnimation;
    }
  }

  
}