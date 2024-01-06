import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class ColliderItem extends PositionComponent with CollisionCallbacks
{
  Function? onCollisionStartFunction;
  Function? onCollisionEndFunction;

  ColliderItem({required super.position, required super.size, this.onCollisionStartFunction, this.onCollisionEndFunction});

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(onCollisionStartFunction != null) onCollisionStartFunction!(intersectionPoints, other);
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if(onCollisionEndFunction != null) onCollisionEndFunction!(other);
    super.onCollisionEnd(other);
  }
}