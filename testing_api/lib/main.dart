import 'package:flutter/material.dart';
import 'package:testing_api/photo_screen.dart';
import 'package:testing_api/testing_postApi.dart';
import 'package:testing_api/users_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const PostReq(),
    );
  }
}