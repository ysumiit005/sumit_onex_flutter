import 'package:flutter/material.dart';
import 'package:sumit_onex_flutter/main.dart';
import 'package:sumit_onex_flutter/projects/inproduction/bloc_counter_example/screen/materialapp.dart';
import 'package:sumit_onex_flutter/projects/inproduction/dio_singleton_template/view/cat_facts_screen.dart';
import 'package:sumit_onex_flutter/projects/inproduction/doc_edgedetect_n_crop/main.dart';
import 'package:sumit_onex_flutter/projects/inproduction/native_wifi_settings/screens/ConnectWifiInternally.dart';
import 'package:sumit_onex_flutter/projects/inproduction/nailesh_sir/screens/autocomplete_widget.dart';
import '../flutmapp_tweenanimation.dart/tweenwidget_flutmapp.dart';
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
    return const Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //
            // home
            //
            SizedBox(
              height: 5,
            ),
            CustomAppDrawerButtons(
              buttonText: 'Home',
              routePage: MyHomePage(),
            ),

            //
            // riverpod example
            //
            CustomAppDrawerButtons(
              buttonText: 'RiverPod Counter Example',
              routePage: UseRiverpod(),
            ),

            //
            // bloc example
            //
            CustomAppDrawerButtons(
              buttonText: 'Bloc Counter Example',
              routePage: BlocCounterExample(),
            ),
            //
            // Naylesh sir signup app with geotag
            //
            CustomAppDrawerButtons(
              buttonText: 'SignUpApp - Naylesh Sir',
              routePage: SignUpPage(),
            ),
            //
            // Naylesh sir autocomplete app
            //
            CustomAppDrawerButtons(
              buttonText: 'AutocompleteApp - Naylesh Sir',
              routePage: AutocompleteExampleApp(),
            ),

            //
            // get wifi connection within app - offee
            //
            CustomAppDrawerButtons(
              buttonText: 'WifiConnect using Native Code',
              routePage: ConnectWifiInternally(),
            ),

            //
            // webview working with custom fixes
            //
            CustomAppDrawerButtons(
              buttonText: 'WebView Working',
              routePage: WebViewScreen(
                title: 'Sumit Onex Custom WebView',
                rexUrl: 'for now didnt added this dynamically',
              ),
            ),

            //
            // doc edge detect and crop
            //
            CustomAppDrawerButtons(
              buttonText: 'PytorchLite - Doc EdgeDetect And Crop',
              routePage: DocEdgeDetectNCrop(),
            ),

            //
            // custom keyboard
            //
            CustomAppDrawerButtons(
              buttonText: 'Custom InApp Keyboard - MultiLanguage',
              routePage: CustomInternalKeyboard(
                title: "Custom InApp Keyboard - MultiLanguage",
              ),
            ),
            //
            //
            // flutter dio singleton
            CustomAppDrawerButtons(
              buttonText: 'Flutter Dio Singleton',
              routePage: CatFactsScreen(),
            ),

            //
            //
            // flutter tween animation - zoom in zoom out
            CustomAppDrawerButtons(
              buttonText: 'Flutter Tween Animation',
              routePage: TweenAnimationFlutter(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppDrawerButtons extends StatelessWidget {
  final Color? materialColor = Colors.purple;
  final Color? splashColor = Colors.grey;
  final String buttonText;

  final Widget routePage;

  const CustomAppDrawerButtons({
    Key? key,
    required this.buttonText,
    required this.routePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: materialColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          splashColor: splashColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => routePage,
              ),
            );
          },
          child: Container(
            height: 50,
            child: Center(
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
