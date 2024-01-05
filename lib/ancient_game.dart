import 'dart:async';

import 'package:ancient_game/Components/input_manager.dart';
import 'package:ancient_game/Components/level.dart';
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
  final double width = 18;
  final double height = 11;

  Screen currentScreen = Screen.mainMenu;

  late CameraComponent cam;
  late World gameWorld;

  final List<String> levels = ['01'];
  int levelIndex = 0;

  FpsTextComponent? fpsText;

  @override
  FutureOr<void> onLoad() async{
    await images.loadAllImages();

    debugMode = debug;
    if(showFPSOverlay){
      fpsText = FpsTextComponent(position: Vector2(0, size.y - 24));
      add(fpsText!);
    }
    inputManager = InputManager.instance;
    
    nextLevel(clear: false);
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


  void changeScreen(bool clear, World nextScreen)
  {
    if(clear) removeAll([cam, gameWorld]);
    gameWorld = nextScreen;
    cam = CameraComponent.withFixedResolution(world:gameWorld ,width: width*blockSize, height: height*blockSize);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, gameWorld]);
  }


  void mainMenu({bool clear = true})
  {
    currentScreen = Screen.mainMenu;
  }


  void credits({bool clear = true})
  {

    currentScreen = Screen.credits;
  }


  void gameOver({bool clear = true})
  {
    currentScreen = Screen.gameOver;
  }


  void nextLevel({bool clear = true, bool retry = false})
  {
    if(!retry) levelIndex++;
    if(currentScreen != Screen.game)
    {
      levelIndex = 0;
    }
    if(levelIndex >= levels.length) return gameOver(clear: clear);
    changeScreen(clear, Level(levelName:levels[levelIndex], debug: debug));
    currentScreen = Screen.game;
  }


}