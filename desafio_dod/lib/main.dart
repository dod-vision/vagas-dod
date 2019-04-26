import 'package:desafio_dod/tabs/camera_tab.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafio DOD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blueAccent
      ),
      home: CameraTab(),
      debugShowCheckedModeBanner: false,
    );
  }
}