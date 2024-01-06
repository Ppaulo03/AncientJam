import 'dart:async';

import 'package:ancient_game/ancient_game.dart';
import 'package:flame/components.dart';

class IndicatorArrow extends SpriteComponent with HasGameRef<AncientGame>{

  Vector2 playerSize;
  IndicatorArrow({required this.playerSize});
  Vector2 direction = Vector2(1, 0);
  Vector2 offset = Vector2(4, 2);

  @override
  FutureOr<void> onLoad() {
    size = Vector2(8, 13);
    position = Vector2(playerSize.x/2 + offset.x, 0) ;
    sprite = Sprite(game.images.fromCache('sprites/player/indicator-arrow.png'));
    anchor = Anchor.center;
    super.onLoad();
  } 

  @override
  void update(double dt) {



    position  = Vector2(0, 0);
    if(direction.x < 0){
      position.x -= playerSize.x/2 + offset.x*direction.x.abs();
    }
    else if(direction.x > 0){
      position.x += playerSize.x/2 + offset.x*direction.x.abs();
    }
    
    if(direction.y < 0){
      position.y -= playerSize.y/2 + offset.y*direction.y.abs();
    }
    else if(direction.y > 0){
      position.y += playerSize.y/2 + offset.y*direction.y.abs();
    }

    angle = direction.angleTo(Vector2(1, 0));
    if(direction.y < 0){
      angle = -angle;
    }
   
    

    
    super.update(dt);
  }
}