import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'audio_controller.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AudioController(),
      child: const MainApp(),
    ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  static const double iconSize = 120.0;

  @override
  Widget build(BuildContext context) {
    var isPlaying = context.watch<AudioController>().isPlaying();
    var isSampling = context.watch<AudioController>().isSampling;
    var playIcon = isPlaying? Icons.stop : Icons.play_arrow;
    var recordIcon = isSampling? Icons.stop : Icons.circle;
    var firstByte = context.select<AudioController, String>((c) => c.audioData.toString());

    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: Icon(playIcon), iconSize: iconSize, onPressed: context.read<AudioController>().togglePlaying,),
                  IconButton(icon: Icon(recordIcon), iconSize: iconSize, color: Colors.red, onPressed: context.read<AudioController>().toggleSampling,),
                ],
              ),
              Text(firstByte, style: const TextStyle(fontSize: 50.0),),
            ],
          ),
        ),
      ),
    );
  }
}
