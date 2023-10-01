import 'dart:async';
import 'dart:typed_data';

/// StreamTransformer that takes a stream of Uint8List and returns a stream of Uint8List
/// of a specific chunkSize for analysis or processing.
class StreamReChunker extends StreamTransformerBase<Uint8List, Uint8List> {
  final int chunkSize;

  StreamReChunker(this.chunkSize);

  @override
  Stream<Uint8List> bind(Stream<Uint8List> stream) async* {
    var bytesReceived = 0;
    var buffer = Uint8List(chunkSize);
    await for (var data in stream) {
      while (bytesReceived + data.length >= chunkSize) {
        buffer.setRange(bytesReceived, chunkSize, data);
        yield buffer;

        // Save the bytes that weren't yeilded
        var remainingBytes = bytesReceived + data.length - chunkSize;
        data = remainingBytes > 0
            ? data.sublist(data.length - remainingBytes)
            : Uint8List(0);

        // Reset our buffer
        bytesReceived = 0;
        buffer = Uint8List(chunkSize);
      }

      if (data.isNotEmpty) {
        buffer.setRange(bytesReceived, bytesReceived + data.length, data);
        bytesReceived += data.length;
      }
    }
  }
}
