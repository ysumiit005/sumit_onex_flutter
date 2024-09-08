import 'package:flutter/material.dart';
import 'package:virtual_keyboard_custom_layout_onex/virtual_keyboard_custom_layout_onex.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Keyboard Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const CustomInternalKeyboard(
        title: 'Virtual Keyboard Demo',
      ),
    );
  }
}

class CustomInternalKeyboard extends StatefulWidget {
  final String title;
  const CustomInternalKeyboard({super.key, required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _CustomInternalKeyboardState createState() => _CustomInternalKeyboardState();
}

class _CustomInternalKeyboardState extends State<CustomInternalKeyboard> {
  // Holds the text that user typed.
  String text = '';

  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  // necessary to maintain the focus and to insert letters in the
  // middle of the string.
  TextEditingController controllerField01 = TextEditingController();
  TextEditingController controllerField02 = TextEditingController();
  TextEditingController controllerField03 = TextEditingController();
  TextEditingController controllerField05 = TextEditingController();

  // key variables to utilize the keyboard with the class KeyboardAux
  var isKeyboardVisible = false;
  var controllerKeyboard = TextEditingController();

  // custom sumit half specify keyboard default language layout
  TypeLayout typeLayout = TypeLayout.alphabet;

  // custom sumit
  late String userLanguage = "english";
  // custom ends

  @override
  void initState() {
    // keyboardListeners();
    super.initState();
  }

  void showSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(' English Language '),
                onTap: () {
                  setState(() {
                    typeLayout = TypeLayout.alphabet;
                    userLanguage = "english";
                    isKeyboardVisible = true;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(' Hindi Language'),
                onTap: () {
                  setState(() {
                    typeLayout = TypeLayout.hindi1;
                    userLanguage = "hindi";
                    isKeyboardVisible = true;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(' Marathi Language'),
                onTap: () {
                  setState(() {
                    typeLayout = TypeLayout.marathi1;
                    userLanguage = "marathi";
                    isKeyboardVisible = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          isKeyboardVisible = false;
        });
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              IconButton(
                  onPressed: () {
                    showSelectionDialog();
                  },
                  icon: const Icon(
                    Icons.one_k,
                  ))
            ],
          ),
          body: Stack(
            children: [
              Center(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      // To prevent overflow with android and ios native keyboard
                      keyboardType: TextInputType.none,
                      controller: controllerField01,
                      maxLines: null,
                      minLines: null,
                      onTap: () {
                        setState(() {
                          isKeyboardVisible = true;
                          controllerKeyboard = controllerField01;
                          // typeLayout = TypeLayout.hindi1;
                        });
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      controller: controllerField02,
                      maxLines: null,
                      minLines: null,
                      onTap: () {
                        setState(() {
                          isKeyboardVisible = true;
                          controllerKeyboard = controllerField02;
                          // typeLayout = TypeLayout.alphaEmail;
                        });
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      controller: controllerField03,
                      maxLines: null,
                      minLines: null,
                      onTap: () {
                        setState(() {
                          isKeyboardVisible = true;
                          controllerKeyboard = controllerField03;
                          // typeLayout = TypeLayout.numeric;
                        });
                      },
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              //
              //
              // sumit onex special keyboard
              //
              //
              if (isKeyboardVisible)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: KeyboardAux(
                    languageChangeCallback: () {
                      showSelectionDialog();
                    },
                    controller: controllerKeyboard,
                    typeLayout: typeLayout,
                    keyboardLanguage: userLanguage,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
