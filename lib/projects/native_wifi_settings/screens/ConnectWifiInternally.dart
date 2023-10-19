import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sumit_onex_flutter/projects/global/custom_app_drawer.dart';

//
//
// entry
//
//
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ConnectWifiInternally(),
    );
  }
}

// main output screen/view keeps track of all state changes
class ConnectWifiInternally extends StatefulWidget {
  const ConnectWifiInternally({super.key});

  @override
  State<ConnectWifiInternally> createState() => _ConnectWifiInternallyState();
}

// main output screen
class _ConnectWifiInternallyState extends State<ConnectWifiInternally> {
  //
  //
  // all ui
  //
  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Connect Wifi Inside App"),
        ),
        drawer: const CustomAppDrawer(),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _getInternalWifiSettings,
                  child: const Text('wifi option only from below '),
                ),
                // wifi with mobile net
                ElevatedButton(
                  onPressed: _getInternalWifiSettingsWithMobileNetwork,
                  child: const Text('wifi option & mobile net from below '),
                ),
                ElevatedButton(
                  onPressed: _getAllWifiList,
                  child: const Text('get all List of Wifi with details '),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(wifiList.toString())
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  //
  // all variables
  //
  //
  // platform specific code
  static const platform = MethodChannel('samples.flutter.dev/battery');
  dynamic wifiList;

  //
  //
  // all functions
  //
  //
  Future<void> _getInternalWifiSettings() async {
    try {
      // final dynamic result =
      await platform.invokeMethod('getOnlyWifiSettingFromBottom');
    } on PlatformException catch (e) {
      print("${e.message}");
    }
  }

  Future<void> _getInternalWifiSettingsWithMobileNetwork() async {
    try {
      // final dynamic result =
      await platform.invokeMethod('getWifiAndMobileNetSettingFromBottom');
    } on PlatformException catch (e) {
      print("${e.message}");
    }
  }

  Future<void> _getAllWifiList() async {
    try {
      final dynamic result = await platform.invokeMethod('getWifiList');

      setState(() {
        wifiList = result;
      });
    } on PlatformException catch (e) {
      print("custom Error Show ${e.message}");
    }
  }

  //
  //
  // all App State
  //
  //
}
