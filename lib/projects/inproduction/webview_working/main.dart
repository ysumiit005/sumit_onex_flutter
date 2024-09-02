import "package:flutter/material.dart";
import 'package:sumit_onex_flutter/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'device_size.dart';

void main() {
  runApp(
    const MaterialApp(
      home: WebViewScreen(
        rexUrl: '',
        title: '',
      ),
    ),
  );
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    super.key,
    required this.title,
    required this.rexUrl,
  });

  final String? title;
  final String? rexUrl;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final WebViewController controller;

  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://www.google.com/'),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
        setState(() {
          loadingPercentage = 0;
        });
      }, onProgress: (progress) {
        setState(() {
          loadingPercentage = progress;
        });
      }, onPageFinished: (url) {
        setState(() {
          loadingPercentage = 100;
        });
      }, onNavigationRequest: (request) {
        if (request.url.startsWith('tel:')) {
          launch(request.url);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      }));
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeviceSize.setScreenSize(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return const MyHomePage();
          }));

          return true;
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 12, 89, 141),
            title: const Center(
              child: Text("Sumit Onex Custom WebView"),
            ),
          ),
          body: Column(
            children: [
              Flexible(
                child: Stack(
                  children: [
                    //
                    // webview
                    //
                    WebViewWidget(
                      controller: controller,
                    ),
                    if (loadingPercentage < 100)
                      Container(
                        height: DeviceSize.height,
                        width: DeviceSize.width,
                        color: Colors.white,
                        child: const Center(
                          // child: CircularProgressIndicator(),
                        ),
                      ),
                    LinearProgressIndicator(
                      value: loadingPercentage / 100.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // endDrawer: const CustomDrawer(),
        ),
      ),
    );
  }
}
