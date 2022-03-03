import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  AudioCache? _audioCache;
  AudioPlayer? _audioPlayer;

  Future init() async {
    _audioCache = AudioCache(prefix: 'assets/sounds/');
    _audioPlayer = AudioPlayer();
  }

  Future play(String file) async {
    _audioPlayer = await _audioCache!.play(file);
  }

  Future loop(String file) async {
    _audioPlayer = await _audioCache!.loop(file);
  }

  Future stop() async {
    _audioPlayer!.stop();
  }
}
