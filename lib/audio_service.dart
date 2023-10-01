import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:record/record.dart';

import 'stream_rechunker.dart';

class AudioService {
  static const sampleBatchSize = 100;
  static const recorderConfig = RecordConfig(
      encoder: AudioEncoder.pcm16bits, sampleRate: 44100, numChannels: 1);
  late AudioRecorder _audioRecorder;
  late Stream<Uint8List> _audioStream; // This is the raw audio stream
  late StreamReChunker rechunker;
  late Stream<Uint8List> _bufferedAudio; // This is the raw audio stream
  Function(int) onAudio;

  AudioService(this.onAudio, {AudioRecorder? audioRecorder}) {
    // Allow recorder to be passed in via constructor for testing
    _audioRecorder = audioRecorder ?? AudioRecorder();
    rechunker = StreamReChunker(sampleBatchSize * 2); // 2 bytes per sample
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
    _bufferedAudio = _audioStream.transform(rechunker);
    _bufferedAudio.listen((Uint8List audioChunk) async {
      await chunkReady(audioChunk);
    });
  }

  Future<void> chunkReady(Uint8List audioChunk) async {
    int maxAmplitude = 0;
    for (int i = 0; i < sampleBatchSize; i += 2) {
      var nextSample = ByteData.sublistView(audioChunk, i, i + 1).getUint16(0, Endian.little);
      maxAmplitude = max(maxAmplitude, nextSample.abs());
    }
    onAudio(maxAmplitude);
  }

  Future<void> stopSampling() async {
    await _audioRecorder.stop();
  }

  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }
}
