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

  @override
  Widget build(BuildContext context) {
    var isSampling = context.watch<AudioController>().isSampling;
    var icon = isSampling? Icons.stop : Icons.play_arrow;
    var amplitude = context.select<AudioController, String>((c) => c.maxAmplitude.toString());

    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(icon: Icon(icon), iconSize: 100.0, onPressed: context.read<AudioController>().toggleSampling,),
              Text(amplitude, style: const TextStyle(fontSize: 50.0),),
            ],
          ),
        ),
      ),
    );
  }
}
