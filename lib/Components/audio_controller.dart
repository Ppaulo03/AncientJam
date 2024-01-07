import 'package:flame_audio/flame_audio.dart';

class AudioController {
  static AudioController? _instance;

  static AudioController get instance {
    _instance ??= AudioController._();
    return _instance!;
  }

  AudioController._();

  bool isMuted = false;

  final Map<String, AudioPlayer> _players = {};

  void addPlayer(String key, String song, {bool loop = false}) {
    if(_players.containsKey(key)) return;
    if(loop)
    {
      FlameAudio.loopLongAudio(song).then((value)
      {
        _players[key] = value;
        value.pause();
      });
    }
    else
    {
      FlameAudio.playLongAudio(song).then((value){
        _players[key] = value;
        value.pause();
      });
    }
  }

  void resume(String key) {
    if(_players.containsKey(key) && !isMuted)
    {
      _players[key]!.resume();
    }
  }
  
  void pause(String key) {
    if(_players.containsKey(key))
    {
      _players[key]!.pause();
    }
  }

  void play(String key) {
    if(isMuted) return;
    FlameAudio.playLongAudio(key);
  }
  
}