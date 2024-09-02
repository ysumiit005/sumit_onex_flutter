import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String cachePath = "";
  String externalPath = "";
  String documentPath = "";

  void getDirectoryPaths() async {
    Directory cacheDirectory = await getTemporaryDirectory();
    Directory? externalDirectory = await getExternalStorageDirectory();
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    setState(() {
      cachePath = cacheDirectory.path;
      externalPath = externalDirectory!.path;
      documentPath = documentDirectory.path;
    });

    print("Cache Directory: $cachePath");
    print("External Directory: $externalPath");
    print("Document Directory: $documentPath");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directory Paths'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Cache Directory: $cachePath"),
            Text("External Directory: $externalPath"),
            Text("Document Directory: $documentPath"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getDirectoryPaths,
              child: const Text('Get Directory Paths'),
            ),
          ],
        ),
      ),
    );
  }
}
