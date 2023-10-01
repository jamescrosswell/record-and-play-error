import 'package:flutter/material.dart';

import 'audio_service.dart';

/// A class that Widgets can interact with to get the most recent Max Amplitude.
class AudioController with ChangeNotifier {
  AudioController()
  {
    _audioService = AudioService(onAudio);
  }

  // Make SettingsService a private variable so it is not used directly.
  late AudioService _audioService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  int audioData = 0;
  void onAudio(int vale){
    audioData = vale;
    notifyListeners();
  }

  bool isSampling = false;

  void toggleSampling()
  {
    if (isSampling)
    {
      stop();
    }
    else{
      start();
    }
  }

  void start()
  {
    _audioService.startSampling();        
    isSampling = true;
    notifyListeners();
  }

  void stop()
  {
    _audioService.stopSampling();
    isSampling = false;
    notifyListeners();
  }
}
