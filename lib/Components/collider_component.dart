import 'package:flame_forge2d/flame_forge2d.dart';

class Ground extends BodyComponent {
  final Vector2 size;
  final Vector2 pos;
  Ground({required this.pos, required this.size});


  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(size.x/2, size.y/2);
    final fixtureDef = FixtureDef(shape);
    final bodyDef = BodyDef()
      ..position = pos
      ..type = BodyType.static;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}