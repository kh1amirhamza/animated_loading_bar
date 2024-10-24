import 'package:flutter/material.dart';
import 'package:animated_loading_bar/animated_loading_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animated Loading Bar Example'),
        ),
        body: Center(
          child: AnimatedLoadingBar(
            colors: [Colors.red, Colors.blue, Colors.green, Colors.purple],
            height: 10.0,
            duration: Duration(seconds: 2),
          ),
        ),
      ),
    );
  }
}
