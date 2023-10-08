import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';

class AudioService {
  static const recorderConfig = RecordConfig(
      encoder: AudioEncoder.pcm16bits, sampleRate: 44100, numChannels: 1);
  late AudioRecorder _audioRecorder;
  late Stream<Uint8List> _audioStream; // This is the raw audio stream
  Function(int) onAudio;

  AudioService(this.onAudio, {AudioRecorder? audioRecorder}) {
    // Allow recorder to be passed in via constructor for testing
    _audioRecorder = audioRecorder ?? AudioRecorder();
    checkDeviceSupport();
  }

  Future<void> checkDeviceSupport() async {
    if (!await _audioRecorder.hasPermission()) {
      throw Exception('Recording is not supported');
    }
    if (!await _audioRecorder.isEncoderSupported(recorderConfig.encoder)) {
      throw Exception('${recorderConfig.encoder.name} is not supported.');
    }
  }

  Future<void> startSampling() async {
    // checkDeviceSupport();

    _audioStream = await _audioRecorder.startStream(recorderConfig);
    _audioStream.listen((Uint8List sample) {
      onAudio(sample.first);
    });
  }

  Future<void> stopSampling() async {
    await _audioRecorder.stop();
  }

  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }
}
