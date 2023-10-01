import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.play_arrow), iconSize: 100.0, onPressed: null,),
              Text("amplitude", style: TextStyle(fontSize: 50.0),),
            ],
          ),
        ),
      ),
    );
  }
}
