import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService extends Object {
  SoundService([AudioPlayer? audioPlayer]) {
    _audioPlayer = audioPlayer ?? AudioPlayer();
  }
  late AudioPlayer _audioPlayer;
  final _metronomeSound = AssetSource('effect.wav');

  Future<void> playSound() async {
      await _audioPlayer.stop();
      await _audioPlayer.play(_metronomeSound);
  }

  @mustCallSuper
  void dispose() {
    _audioPlayer.dispose();
  }
}
