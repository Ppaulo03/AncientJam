import 'dart:async';

import 'package:ancient_game/Itens/alien_computer.dart';
import 'package:ancient_game/Itens/alien_device_pickable.dart';
import 'package:ancient_game/Itens/door.dart';
import 'package:ancient_game/Itens/readable.dart';
import 'package:ancient_game/Itens/scannable_item.dart';
import 'package:ancient_game/Player/player.dart';
import 'package:ancient_game/ancient_game.dart';
import 'package:flame/collisions.dart';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';


class Level extends Forge2DWorld with HasGameRef<AncientGame>{
  final bool debug;
  final String levelName;
  
  

  Level({required this.levelName, this.debug = false});
  
  @override
  FutureOr<void> onLoad() async{
    final TiledComponent level = await TiledComponent.load('dungeon.tmx', Vector2.all(16) ,useAtlas: false,atlasMaxX: 500,atlasMaxY: 500);
    await FlameAudio.bgm.stop();
    await FlameAudio.bgm.play('background.wav', volume: 0.05);
    add(level);
    _addColliders(level.tileMap);
    _addObjects(level.tileMap);
    await _addUI();

  }
  
  _addColliders(RenderableTiledMap  tileMap)
  {
    final layer = tileMap.getLayer<ObjectGroup>('Collision');
    if (layer == null) return;

    for (final object in layer.objects) {
      final objcposition = Vector2(object.x + object.width/2, object.y + object.height/2);
      switch(object.class_) {
        default:
          add( 
            BodyComponent(
              renderBody: game.debug,
              paint: Paint()
                ..color = const Color.fromARGB(255, 1, 241, 53)
                ..style = PaintingStyle.stroke,
                
              fixtureDefs: [FixtureDef(
                PolygonShape()..setAsBoxXY(object.width/2, object.height/2),
                friction: 0,
              )],
              bodyDef: BodyDef(
                position: Vector2(objcposition.x , objcposition.y),
                type: BodyType.static,
              ),
            )
          );
          add(
            RectangleComponent(
              paint: Paint()
                ..color = const Color.fromARGB(0, 0, 241, 255)
                ..style = PaintingStyle.stroke,
              position: Vector2(object.x, object.y),
              size: Vector2(object.width, object.height),
              children: [RectangleHitbox()..debugMode = game.debug],
            )
          );
          
          break;
      }
    }
  }


  _addObjects(RenderableTiledMap  tileMap)
  {
    final layer = tileMap.getLayer<ObjectGroup>('SpawnPoint');
    if (layer == null) return;

    for (final object in layer.objects) {
      Vector2 position = Vector2(object.x, object.y);
      switch(object.class_) {
        //add case to add objects
        case 'Player':
          final Player player = Player(pos: position);
          add(player); 
          break;
        case 'ScannableItem':
          print(object.properties['description']!.value);
          add(ScannableItem(pos:position)
              ..spriteName = object.name
              ..description = object.properties['description']!.value as String
              );
          break;

        case 'AlienComputer':
          add(AlienComputer(pos:position));
          break;

        case 'AlienDevice':
          add(AlienDevicePickable(pos:position));
          break;
        
        case 'Door':
          game.door = Door(pos:position);
          add(game.door!);
          break;

        case 'Readable':
          add(Readable(pos: position));
        default:
          break;
      }
    }
  }


  _addUI() async{

    final TiledComponent ui = await TiledComponent.load('Ui.tmx', Vector2.all(16), useAtlas: false);
    final elements = ui.tileMap.getLayer<ObjectGroup>('UI');
    if (elements == null) return;
    for (final object in elements.objects) {
      switch(object.class_) {
        //add case to add UI elements
        default:
          break;
      }
    }
  }

}