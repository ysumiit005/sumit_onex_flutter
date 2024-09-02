import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/custom_app_drawer.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  File? _pickedImage;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? geotagInfo;

  @override
  void initState() {
    super.initState();

    _loadImageFromSharedPreferences();
  }

  Future<void> _loadImageFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      setState(() {
        _pickedImage = File(imagePath);
        print(imagePath);
      });
    }
  }

  Future<void> _saveImageToSharedPreferences(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', imagePath);
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);

      final tags = await readExifFromBytes(await imageFile.readAsBytes());
      if (tags.isNotEmpty) {
        final gpsInfo = tags['GPS GPSLongitude'] ?? '';
        final gpsLat = tags['GPS GPSLatitude'] ?? '';
        geotagInfo = 'GPS Longitude: $gpsInfo, GPS Latitude: $gpsLat';
      } else {
        geotagInfo = 'No geotag information found.';
      }

      // Save the image path to SharedPreferences
      await _saveImageToSharedPreferences(imageFile.path);

      setState(() {
        _pickedImage = imageFile;
        print(_pickedImage);
      });
    }
  }

  void submit() async {
    if (_pickedImage != null) {
    } else {
      print('Please pick an image first.');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up with Geotag on Image"),
        ),
        drawer: const CustomAppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Pick Photo from Gallery'),
                            onTap: () {
                              pickImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_camera),
                            title: const Text('Take a Photo using Camera'),
                            onTap: () {
                              pickImage(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: _pickedImage != null
                      ? ClipOval(
                          child: Image.file(
                            _pickedImage!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submit,
                child: const Text('Submit'),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Email id    - ${emailController.text} \nPassword    - ${passwordController.text} \n"
                  "Geotag Info - $geotagInfo",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// models
//

class ImageData {
  final String email;
  final String password;
  final String imagePath;
  final String geotagInfo;

  ImageData({
    required this.email,
    required this.password,
    required this.imagePath,
    required this.geotagInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'imagePath': imagePath,
      'geotagInfo': geotagInfo,
    };
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpPage(),
  ));
}
