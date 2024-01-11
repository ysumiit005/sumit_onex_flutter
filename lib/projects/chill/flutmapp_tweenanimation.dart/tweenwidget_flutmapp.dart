import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double targetValue = 24;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
