import 'dart:async';


import 'package:ancient_game/Screens/ui_element.dart';
import 'package:ancient_game/Screens/background_tile.dart';
import 'package:ancient_game/ancient_game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';


class MainMenu extends Forge2DWorld with HasGameRef<AncientGame>{
  @override
  FutureOr<void> onLoad(){
    addAll([
      BackgroundTile(),
      UIButton(size: Vector2(33,12), position: Vector2(game.blockSize/2*game.width,70), label: 'Play',   onTap: game.nextLevel), 
      UIButton(size: Vector2(57.5,12), position: Vector2(game.blockSize/2*game.width,90),label:'Credits', onTap: game.credits)
      ]);
    return super.onLoad();
  }
}


class Credits extends Forge2DWorld with HasGameRef<AncientGame>
{
  @override
  FutureOr<void> onLoad(){
    addAll([
      BackgroundTile(),
      UITextElement(size: 5, position: Vector2(game.blockSize/2*game.width, 45) , color: const Color(0xFFFFFFFF), text: 'Game Development: Devgez & Ppaulo03 '),
      UITextElement(size: 5, position: Vector2(game.blockSize/2*game.width, 60) , color: const Color(0xFFFFFFFF), text: 'Programmer: Ppaulo03'),
      UITextElement(size: 5, position: Vector2(game.blockSize/2*game.width, 75) , color: const Color(0xFFFFFFFF), text: 'Art Directon: Devgez'),
      UIButton(position: Vector2(game.blockSize/2*game.width,100), color:const Color(0xFF819796), label: 'Back to Menu', size: Vector2(100,12), onTap: game.mainMenu)
    ]);    
    return super.onLoad();
  }
}


class GameOver extends Forge2DWorld with HasGameRef<AncientGame>
{
  @override
  FutureOr<void> onLoad(){

    addAll([
      BackgroundTile(),
      UITextElement(position: Vector2(game.blockSize/2*game.width, 40), color:const Color(0xFF819796), size: 8, text: 'That is the end for now',),
      UITextElement(position: Vector2(game.blockSize/2*game.width, 60), color:const Color(0xFFFFFFFF), size: 5, text: 'Thanks For Playing!'),
      UIButton(position: Vector2(game.blockSize/2*game.width,100), color:const Color(0xFF819796), label: 'Credits', size: Vector2(57.5,12), onTap: game.credits)
    ]);    

    void changeScreen()
    {
      if(game.currentScreen == Screen.gameOver)
      {
        game.credits();
      }
    }

    //Future.delayed(const Duration(seconds: 6), changeScreen);
    return super.onLoad();
  }
}
