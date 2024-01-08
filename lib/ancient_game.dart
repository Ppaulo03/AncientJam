import 'dart:async';

import 'package:ancient_game/Components/input_manager.dart';
import 'package:ancient_game/Components/level.dart';
import 'package:ancient_game/Itens/door.dart';
import 'package:ancient_game/Screens/screens.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide World;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum Screen {mainMenu, game, credits, gameOver}


class AncientGame extends Forge2DGame with KeyboardEvents, HasCollisionDetection{

  bool onMobile, debug, showFPSOverlay;
  AncientGame({this.onMobile = false, this.debug = false, this.showFPSOverlay = false});
  late InputManager inputManager;

  
  //Screen size
  final double blockSize = 16;
  final double width = 40;
  final double height = 22;

  Screen currentScreen = Screen.mainMenu;

  late CameraComponent cam;
  late Forge2DWorld gameWorld;

  final List<String> levels = ['01'];
  int levelIndex = 0;

  FpsTextComponent? fpsText;
  String password = 'mnlcgelij';

  bool gotIt = false;
  Door? door;

  @override
  FutureOr<void> onLoad() async{
    await images.loadAllImages();

    debugMode = debug;
    if(showFPSOverlay){
      fpsText = FpsTextComponent(position: Vector2(0, size.y - 24));
      add(fpsText!);
    }
    inputManager = InputManager.instance;
    
    mainMenu(clear: false);
    await super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    fpsText?.position = Vector2(0, size.y - 24);
    super.onGameResize(size);
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed,) {
    if(!onMobile) inputManager.setKeyBoardEvent(event, keysPressed);
    return KeyEventResult.handled;
  }


  void changeScreen(bool clear, Forge2DWorld nextScreen)
  {
    if(clear) removeAll([cam, gameWorld]);
    gameWorld = nextScreen;
    
    cam = CameraComponent.withFixedResolution(world:gameWorld ,width: width*blockSize/2, height: height*blockSize/2);
    if(currentScreen != Screen.game) cam.viewfinder.anchor = Anchor.topLeft;
    
   
    addAll([cam, gameWorld]);
  }


  void mainMenu({bool clear = true})
  {
    currentScreen = Screen.mainMenu;
    changeScreen(clear, MainMenu());
  }


  void credits({bool clear = true})
  {
    currentScreen = Screen.credits;
    changeScreen(clear, Credits());
  }


  void gameOver({bool clear = true})
  {
    currentScreen = Screen.gameOver;
    changeScreen(clear, GameOver());
  }


  void nextLevel({bool clear = true, bool retry = false})
  {
    if(!retry) levelIndex++;
    if(currentScreen != Screen.game)
    {
      levelIndex = 0;
    }
    gotIt = false;
    if(levelIndex >= levels.length) return gameOver(clear: clear);
    currentScreen = Screen.game;
    changeScreen(clear, Level(levelName:levels[levelIndex], debug: debug));
    
  }


  int checkAnswer(String answer)
  {
    final firstItem = password.substring(0, 1);
    final firstAnswer = answer.substring(0, 1);

    // get pairs off chars
    final pairs = <String>[];
    final realPairs = <String>[];
    for (var i = 1; i < password.length - 1; i+=2) {
      pairs.add(password.substring(i, i + 2));
      realPairs.add(answer.substring(i, i + 2));
    }
    int contRights = 0;
    if (firstItem == firstAnswer) {
      contRights++;
    }
    for (int i = 0; i < pairs.length; i++) {
      if (pairs[i] == realPairs[i] || pairs[i].split('').reversed.join() == realPairs[i]) {
        contRights++;
      }
    }
    return contRights;
  }

  void openDoor()
  {
    if(gotIt) return;
    gotIt = true;
    door?.open();
  }
  
}