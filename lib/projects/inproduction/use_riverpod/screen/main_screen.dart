import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../global/custom_app_drawer.dart';
import '../state/provider.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UseRiverpod(),
    );
  }
}

class UseRiverpod extends ConsumerWidget {
  const UseRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterStateProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("counter using riverpod"),
        ),
        drawer: const CustomAppDrawer(),
        body: Center(
            child: Text(
          'Value: $counter',
          style: Theme.of(context).textTheme.headlineLarge,
        )),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: "btn2",
                onPressed: () =>
                    ref.read(counterStateProvider.notifier).state--,
                child: const Icon(Icons.remove),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NextScreen(),
                      ),
                    );
                  },
                  child: const Text("next")),
              FloatingActionButton(
                heroTag: "btn1",
                onPressed: () =>
                    ref.read(counterStateProvider.notifier).state++,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextScreen extends ConsumerWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("counter using riverpod"),
      ),
      body: Center(
          child: Text(
        'Value: $counter',
        style: Theme.of(context).textTheme.headlineLarge,
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("back")),
        ],
      ),
    );
  }
}
