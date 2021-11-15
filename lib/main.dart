import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tune_up/controllers/player_controller.dart';
import 'package:tune_up/controllers/songs_controller.dart';
import 'package:tune_up/views/mainScreen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PlayerController());
    Get.put(SongsController());
    return MaterialApp(
      title: 'Tune Up',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
