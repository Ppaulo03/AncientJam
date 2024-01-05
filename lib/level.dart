import 'dart:async';


import 'package:ancient_game/ancient_game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';


class Level extends World with HasGameRef<AncientGame>{
  final bool debug;
  final String levelName;

  Level({required this.levelName, this.debug = false});


  @override
  FutureOr<void> onLoad() async{
    final TiledComponent level = await TiledComponent.load('level-$levelName.tmx', Vector2.all(16), useAtlas: false);
    add(level);
    
    _addObjects(level.tileMap);
    _addColliders(level.tileMap); 
  }



  _addColliders(RenderableTiledMap  tileMap)
  {
    final layer = tileMap.getLayer<ObjectGroup>('Collision');
    if (layer == null) return;

    for (final object in layer.objects) {
      switch(object.class_) {
        default:
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
        default:
          break;
      }
    }
  }

}