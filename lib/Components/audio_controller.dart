class AudioController {
  static AudioController? _instance;

  static AudioController get instance {
    _instance ??= AudioController._();
    return _instance!;
  }

  AudioController._();

  
}