import "package:flutter/material.dart";

import "../data/remote/api_service.dart";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dio Singleton Example'),
        ),
        body: Center(
          child: FutureBuilder(
            future: ApiService().fetchCatFact(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('Check your console for output.');
              }
            },
          ),
        ),
      ),
    );
  }
}
