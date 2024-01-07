import 'package:ancient_game/ancient_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


void main() {
  AncientGame game = AncientGame();
  runApp(GameWidget(game: kDebugMode? AncientGame(onMobile: false, debug:false, showFPSOverlay:true) : game,));
}

