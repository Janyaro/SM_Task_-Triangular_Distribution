import 'package:flutter/material.dart';
import 'package:sm_task/Triangle.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white , fontSize: 25),
        )
      ),
      home: TriangularCalculator(),
    );
  }
}