import 'dart:ui';
import 'package:flame/components.dart';


class ScannerEffect extends PositionComponent{

  ScannerEffect(Vector2 size):super(size: size, position: Vector2(0, 0));

  bool scan = false; 
  bool isScanning = false;
  double _scanPosition = 0;
  int _direction = -1;
  double scanSpeed = 25;


  @override
  void update(double dt) {
    if (isScanning) {
      _scanPosition += dt * scanSpeed * _direction;
      if (_scanPosition < 0) {
        _scanPosition = 0;
        _direction = -_direction;
      } else if (_scanPosition >= size.y) {
        _scanPosition = size.y;
        isScanning = false;
      }
    }
    else if(scan)
    {
      _scanPosition = size.y;
      isScanning = true;
      scan = false;
      _direction = -1;
    }
  }
  

  @override
  void render(Canvas canvas){
    if (isScanning) {
      canvas.drawRect(
        Rect.fromLTWH(0, _scanPosition, size.x, 1),
        Paint()..color = const Color(0xFF00FF00),
      );
    }
  }
    

}