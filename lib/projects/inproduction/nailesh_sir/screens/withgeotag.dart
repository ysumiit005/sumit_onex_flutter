import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';

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

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      // get file path
      final imageFile = File(pickedImage.path);

      //
      // reads meta data of imagefile
      //
      final tags = await readExifFromBytes(await imageFile.readAsBytes());
      if (tags.isNotEmpty) {
        final gpsInfo = tags['GPS GPSLongitude'] ?? '';
        final gpsLat = tags['GPS GPSLatitude'] ?? '';
        geotagInfo = 'GPS Longitude: $gpsInfo, GPS Latitude: $gpsLat';
      } else {
        geotagInfo = 'No geotag information found.';
      }

      setState(() {
        _pickedImage = imageFile;
      });
    }
  }

  void submit() {
    // get entered email and password
    final email = emailController.text;
    final password = passwordController.text;

    // print all variables
    print('Email: $email');
    print('Password: $password');
    if (geotagInfo != null) {
      print('Geotag Info: $geotagInfo');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("sign up with geo tag on image"),
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
              //
              // submit button
              //
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
