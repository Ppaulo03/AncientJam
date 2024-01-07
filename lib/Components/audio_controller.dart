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

  void addPlayer(String key, String song, {bool loop = false, double volume = 1}) {
    if (_players.containsKey(key)) return;
    if (loop) {
      FlameAudio.loopLongAudio(song, volume: volume).then((value) {
        _players[key] = value;
        value.pause();
      });
    } else {
      FlameAudio.playLongAudio(song, volume: volume).then((value) {
        _players[key] = value;
        value.pause();
      });
    }
  }

  void resume(String key) {
    if (_players.containsKey(key) && !isMuted) {
       if (_players[key]!.state == PlayerState.paused) {
             _players[key]!.resume();
      }
    }
  }

  void pause(String key) {
    if (_players.containsKey(key)) {
      if (_players[key]!.state == PlayerState.playing) {
        _players[key]!.pause();
      }
    }
  }

  void play(String key) {
    if (isMuted) return;
    FlameAudio.playLongAudio(key);
  }
}
