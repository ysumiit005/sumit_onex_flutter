import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: KeyboardScreen(),
    );
  }
}

class KeyboardScreen extends StatefulWidget {
  const KeyboardScreen({super.key});

  @override
  _KeyboardScreenState createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {
  String inputText = '';
  bool isKeyboardVisible = true; // Initially set to true

  void onKeyPressed(String key) {
    setState(() {
      inputText += key;
    });
  }

  void onDeletePressed() {
    setState(() {
      if (inputText.isNotEmpty) {
        inputText = inputText.substring(0, inputText.length - 1);
      }
    });
  }

  void toggleKeyboardVisibility() {
    setState(() {
      isKeyboardVisible = !isKeyboardVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Keyboard Sumit'),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: toggleKeyboardVisibility,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        inputText,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: toggleKeyboardVisibility,
                  child: Text(
                      isKeyboardVisible ? 'Hide Keyboard' : 'Show Keyboard'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: isKeyboardVisible
                ? Keyboard(onKeyTapped: onKeyPressed, onDelete: onDeletePressed)
                : Container(),
          ),
        ],
      ),
    );
  }
}

class Keyboard extends StatelessWidget {
  final Function(String) onKeyTapped;
  final VoidCallback onDelete;

  Keyboard({required this.onKeyTapped, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              KeyButton(text: '1', onPressed: () => onKeyTapped('1')),
              KeyButton(text: '2', onPressed: () => onKeyTapped('2')),
              KeyButton(text: '3', onPressed: () => onKeyTapped('3')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              KeyButton(text: '4', onPressed: () => onKeyTapped('4')),
              KeyButton(text: '5', onPressed: () => onKeyTapped('5')),
              KeyButton(text: '6', onPressed: () => onKeyTapped('6')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              KeyButton(text: '7', onPressed: () => onKeyTapped('7')),
              KeyButton(text: '8', onPressed: () => onKeyTapped('8')),
              KeyButton(text: '9', onPressed: () => onKeyTapped('9')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              KeyButton(text: '0', onPressed: () => onKeyTapped('0')),
              KeyButton(text: '<-', onPressed: onDelete),
            ],
          ),
          SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
}

class KeyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  KeyButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
