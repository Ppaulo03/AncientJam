import 'dart:async';


import 'package:ancient_game/Screens/ui_element.dart';
import 'package:ancient_game/Screens/background_tile.dart';
import 'package:ancient_game/ancient_game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';


class MainMenu extends Forge2DWorld with HasGameRef<AncientGame>{
  @override
  Future<FutureOr<void>> onLoad() async {
    //await FlameAudio.bgm.stop();
    //await FlameAudio.bgm.play('radio.wav', volume: 0.005);
    addAll([
      BackgroundTile(),
      UITextElement(size: 20, position: Vector2(game.blockSize/2*game.width/2, 45) , color: const Color(0xFFFFFFFF), text: "BABEL'S DUNGEON"),
      UIButton(
          size: Vector2(33, 12),
          position: Vector2(game.blockSize / 2 * game.width / 2, 70),
          label: 'Play',
          onTap: () async {
          game.nextLevel.call();
           await FlameAudio.bgm.stop();
           await FlameAudio.bgm.play('background.wav', volume: 0.05);

          }), 
      UIButton(size: Vector2(57.5,12), position: Vector2(game.blockSize/2*game.width/2,90),label:'Credits', onTap: game.credits)

      ]);
     super.onLoad();
  }

}


class Credits extends Forge2DWorld with HasGameRef<AncientGame>
{
  @override
  FutureOr<void> onLoad(){
    addAll([
      BackgroundTile(),
      UITextElement(size: 5, position: Vector2(game.blockSize/2*game.width/2, 45) , color: const Color(0xFFFFFFFF), text: 'Game Development: Devgez & Ppaulo03 '),
      UITextElement(size: 5, position: Vector2(game.blockSize/2*game.width/2, 60) , color: const Color(0xFFFFFFFF), text: 'Programmer: Ppaulo03'),
      UITextElement(size: 5, position: Vector2(game.blockSize/2*game.width/2, 75) , color: const Color(0xFFFFFFFF), text: 'Art Directon: Devgez'),
      UIButton(position: Vector2(game.blockSize/2*game.width/2,100),color:const Color(0xffc0cbdc), label: 'Back to Menu', size: Vector2(100,12), onTap: game.mainMenu)
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
      UITextElement(position: Vector2(game.blockSize/2*game.width/2, 40), color:const Color(0xFFFFFFFF), size: 8, text: 'That is the end for now',),
      UITextElement(position: Vector2(game.blockSize/2*game.width/2, 60), color:const Color(0xFFFFFFFF), size: 5, text: 'Thanks For Playing!'),
      UIButton(position: Vector2(game.blockSize/2*game.width/2,100),color: const Color(0xffc0cbdc), label: 'Credits', size: Vector2(57.5,12), onTap: game.credits)
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
