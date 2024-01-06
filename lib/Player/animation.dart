import 'dart:async';

import 'package:ancient_game/ancient_game.dart';
import 'package:flame/components.dart';

enum PlayerState {
  idle,
  running,
}

class PlayerAnimationAssets extends SpriteAnimationGroupComponent with HasGameRef<AncientGame>{

  final Vector2 textureSize = Vector2(13, 17);
  PlayerAnimationAssets({super.position});

  SpriteAnimation _addAnimation(animacao, amount, stepTime)
  {
    
    final data = SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: stepTime,
      textureSize: textureSize,
    );
    String path = 'sprites/player/player-$animacao-sheet.png';

    final animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(path), data);


    return animation;
  }


  @override
  FutureOr<void> onLoad(){
    //Travel position from center to top left of itself
    position = Vector2(position.x - textureSize.x/2, position.y - textureSize.y/2);

    priority = 31;
    debugMode = game.debug;
    size = textureSize;
    animations = {
      PlayerState.idle: _addAnimation('idle', 2, 0.25),
      PlayerState.running: _addAnimation('run', 4, 0.1),
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