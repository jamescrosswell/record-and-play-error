import 'dart:async';

import 'package:flutter/material.dart';

import 'audio_service.dart';
import 'sounds.dart';

/// A class that Widgets can interact with to get the most recent Max Amplitude.
class AudioController with ChangeNotifier {
  AudioController()
  {
    _audioService = AudioService(onAudio);
    _soundService = SoundService();
  }

  // Make SettingsService a private variable so it is not used directly.
  late AudioService _audioService;
  late SoundService _soundService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  int audioData = 0;
  void onAudio(int vale){
    audioData = vale;
    notifyListeners();
  }


  void _playEffect()
  {
    _soundService.playSound();
  }

  Timer? timer;
  void _startTimer() {
    timer = Timer.periodic(
        const Duration(milliseconds: 3000),
        (timer) async {
          _playEffect();
        }
    );
    notifyListeners();
  }

  void _stopTimer() {
    timer?.cancel();
    timer = null;
    notifyListeners();
  }

  void togglePlaying()
  {
    if (timer != null)
    {
      _stopTimer();
    }
    else{
      _startTimer();
    }
  }
  bool isPlaying() => timer!= null;

  bool isSampling = false;

  void toggleSampling()
  {
    if (isSampling)
    {
      stopSampling();
    }
    else{
      startSampling();
    }
  }

  void startSampling()
  {
    _audioService.startSampling();        
    isSampling = true;
    notifyListeners();
  }

  void stopSampling()
  {
    _audioService.stopSampling();
    isSampling = false;
    notifyListeners();
  }
}
