import 'package:flutter/services.dart';
import 'package:flame/components.dart';


enum Command{
  moveLeft, moveRight, jump, useItem, moveUp, moveDown
}

class InputManager extends Component{
  static InputManager? _instance;

  static InputManager get instance {
    _instance ??= InputManager._();
    return _instance!;
  }

  InputManager._();

  final Map<Command, bool> commands = {
    Command.moveLeft: false,
    Command.moveRight: false,
    Command.moveUp: false,
    Command.moveDown: false,
    Command.useItem: false,
  };
  
  void setKeyBoardEvent(RawKeyEvent event,  Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    // Avoiding repeat event as we are interested only in
    // key up and key down event.
    if (!event.repeat) {
      if (event.logicalKey == LogicalKeyboardKey.keyA || event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setCommand(Command.moveLeft, isKeyDown);
      } else if (event.logicalKey == LogicalKeyboardKey.keyD || event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setCommand(Command.moveRight, isKeyDown);
      } 
      else if (event.logicalKey == LogicalKeyboardKey.keyW || event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setCommand(Command.moveUp, isKeyDown);
      } 
      else if (event.logicalKey == LogicalKeyboardKey.keyS || event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setCommand(Command.moveDown, isKeyDown);
      }
      else if (event.logicalKey == LogicalKeyboardKey.keyE) {
        setCommand(Command.useItem, isKeyDown);
      }
    }
  }

  void setCommand(Command command, bool value){
    commands[command] = value;
  }

  
}

