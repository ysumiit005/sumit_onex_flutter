import 'package:flutter/material.dart';
import 'package:sumit_onex_flutter/main.dart';
import 'package:sumit_onex_flutter/projects/bloc_counter_example/screen/materialapp.dart';
import 'package:sumit_onex_flutter/projects/native_wifi_settings/screens/ConnectWifiInternally.dart';
import 'package:sumit_onex_flutter/projects/nailesh_sir/screens/autocomplete_widget.dart';

import '../nailesh_sir/screens/withgeotaganddatabase.dart';
import '../use_riverpod/screen/main_screen.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // home
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
                child: const Text("Home"),
              ),
            ),
            // riverpod example
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UseRiverpod(),
                    ),
                  );
                },
                child: const Text("RiverPod Counter Example"),
              ),
            ),
            // bloc example
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BlocCounterExample(),
                    ),
                  );
                },
                child: const Text("Bloc Counter Example"),
              ),
            ),
            //
            // Naylesh sir signup app with geotag
            //
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
                child: const Text("SignUpApp - Naylesh Sir"),
              ),
            ),
            //
            // Naylesh sir autocomplete app
            //
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AutocompleteExampleApp(),
                    ),
                  );
                },
                child: const Text("AutocompleteApp - Naylesh Sir"),
              ),
            ),
            //
            // get wifi connection within app - offee
            //
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConnectWifiInternally(),
                    ),
                  );
                },
                child: const Text("WifiConnect using Native Code - Offee"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
