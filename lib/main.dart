import 'package:appiumtesting/counter_app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const PracticeApp());
}

class PracticeApp extends StatefulWidget {
  const PracticeApp({super.key});

  @override
  State<PracticeApp> createState() => _PracticeAppState();
}

class _PracticeAppState extends State<PracticeApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
      ),

      home: CounterApp(),
    );
  }
}
