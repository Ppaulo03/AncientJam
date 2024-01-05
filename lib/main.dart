import 'package:ancient_game/ancient_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform/platform.dart';


void main() {
  bool  onMobile = const LocalPlatform().isAndroid || const LocalPlatform().isIOS; // need testing
  AncientGame game = AncientGame();
  runApp(GameWidget(game: kDebugMode? AncientGame(onMobile: onMobile, debug:true, showFPSOverlay:true) : game,));
}

