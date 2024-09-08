import 'package:flutter/material.dart';
import 'package:sumit_onex_flutter/main.dart';
import 'package:sumit_onex_flutter/projects/inproduction/bloc_counter_example/screen/materialapp.dart';
import 'package:sumit_onex_flutter/projects/inproduction/dio_singleton_template/view/cat_facts_screen.dart';
import 'package:sumit_onex_flutter/projects/inproduction/doc_edgedetect_n_crop/main.dart';
import 'package:sumit_onex_flutter/projects/inproduction/native_wifi_settings/screens/ConnectWifiInternally.dart';
import 'package:sumit_onex_flutter/projects/inproduction/nailesh_sir/screens/autocomplete_widget.dart';
import '../nailesh_sir/screens/withgeotaganddatabase.dart';
import '../onex_sumit_keyboards/sumit_custom_keyboards_onex.dart';
import '../use_riverpod/screen/main_screen.dart';
import '../webview_working/main.dart';

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
                child: const Text("WifiConnect using Native Code"),
              ),
            ),
            //
            // webview working with custom fixes
            //
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewScreen(
                        title: 'Sumit Onex Custom WebView',
                        rexUrl: 'for now didnt added this dynamically',
                      ),
                    ),
                  );
                },
                child: const Text("WebView Working"),
              ),
            ),
            //
            // doc edge detect and crop
            //
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DocEdgeDetectNCrop(),
                    ),
                  );
                },
                child: const Text("PytorchLite - Doc EdgeDetect And Crop"),
              ),
            ),
            //
            // custom keyboard
            //
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomInternalKeyboard(
                        title: 'custom keyboard',
                      ),
                    ),
                  );
                },
                child: const Text("Custom InApp Keyboard - MultiLanguage"),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CatFactsScreen(
                          // title: 'Flutter Dio Singleton Template Example',
                          ),
                    ),
                  );
                },
                child: const Text("Flutter Dio Singleton"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
