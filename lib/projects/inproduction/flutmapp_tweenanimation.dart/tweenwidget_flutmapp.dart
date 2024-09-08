import 'package:flutter/material.dart';

import '../global/custom_app_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TweenAnimationFlutter(),
    );
  }
}

class TweenAnimationFlutter extends StatefulWidget {
  const TweenAnimationFlutter({super.key});

  @override
  State<TweenAnimationFlutter> createState() => _TweenAnimationFlutterState();
}

class _TweenAnimationFlutterState extends State<TweenAnimationFlutter> {
  double targetValue = 24;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tween Animation Flutter"),
        ),
        drawer: const CustomAppDrawer(),
        body: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: targetValue),
            duration: const Duration(seconds: 1),
            builder: (BuildContext context, double size, Widget? child) {
              return IconButton(
                onPressed: () {
                  targetValue = targetValue == 24
                      ? MediaQuery.of(context).size.width * 0.9
                      : 24;
                  setState(() {});
                },
                icon: const Icon(Icons.flutter_dash),
                color: Colors.orangeAccent,
                iconSize: size,
              );
            },
          ),
        ),
      ),
    );
  }
}
