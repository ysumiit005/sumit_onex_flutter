import 'package:flutter/material.dart';
import 'screens/withgeotag.dart';

//
// start
//
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('SignUp'),
          ),
          body: const Center(
            child: SignUpPage(),
          ),
        ),
      ),
    );
  }
}
