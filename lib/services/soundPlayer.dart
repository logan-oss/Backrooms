import 'package:flutter_sound_lite/public/flutter_sound_player.dart';

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;

  Future init() async {
    _audioPlayer = FlutterSoundPlayer();
    await _audioPlayer!.openAudioSession();
  }

  Future dispose() async {
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }

  Future play() async {
    try {
      await _audioPlayer!.startPlayer(
        fromURI: 'assets/sounds/safe_level.mp3',
      );
    } catch (e) {
      print(e);
    }
  }

  Future stop() async {
    await _audioPlayer!.stopPlayer();
  }

  Future _togglePlaying() async {
    if (_audioPlayer!.isStopped) {
      await play();
    } else {
      await stop();
    }
  }
}
