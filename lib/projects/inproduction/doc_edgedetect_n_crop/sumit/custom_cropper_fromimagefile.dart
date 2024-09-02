import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crop_your_image/crop_your_image.dart';
// import 'package:pytorch_lite/classes/result_object_detection.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Asset Image to Variable'),
        ),
        // body: const CustomImageCropperFromImageFile(
        //   detectedImage: null,
        //   getDetectedObj: PyTorchRect(),
        // ),
      ),
    );
  }
}

class CustomImageCropperFromImageFile extends StatefulWidget {
  const CustomImageCropperFromImageFile(
      {Key? key, required this.detectedImage, required this.getDetectedObj})
      : super(key: key);

  final XFile?
      detectedImage; // take image which is processed after object detection

  final PyTorchRect getDetectedObj;

  @override
  _CustomImageCropperFromImageFileState createState() =>
      _CustomImageCropperFromImageFileState();
}

class _CustomImageCropperFromImageFileState
    extends State<CustomImageCropperFromImageFile> {
  Uint8List? _image;
  final con = CropController();
  bool cropped = false;
  late final Uint8List croppedIMage;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    // ByteData image = await rootBundle.load('assets/sample_image.jpg');
    Uint8List imageData = await widget.detectedImage!
        .readAsBytes(); // convert taken image xfile to uni8list
    // ByteData image = await rootBundle.load(widget.detectedImage!.path);
    setState(() {
      _image = imageData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: _image != null
            ? cropped
                ? Image.memory(croppedIMage)
                : Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraints) {
                          double factorX = constraints.maxWidth;
                          double factorY = constraints.maxHeight;
                          return Crop(
                              cornerDotBuilder: (size, edgeAlignment) {
                                return const DotControl(
                                  color: Colors.red,
                                );
                              },
                              // maskColor: Colors.black,
                              initialAreaBuilder: ((imageRect) {
                                return Rect.fromLTRB(
                                    widget.getDetectedObj.left * factorX,
                                    widget.getDetectedObj.top * factorY,
                                    widget.getDetectedObj.right * factorX,
                                    widget.getDetectedObj.bottom * factorY);
                              }),
                              image: _image!,
                              controller: con,
                              onCropped: (image) {
                                // do something with image data
                                setState(() {
                                  croppedIMage = image;
                                  cropped = true;
                                });
                              });
                        }),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            con.crop();
                          },
                          child: Text("Crop"))
                    ],
                  )
            : CircularProgressIndicator(),
      ),
    );
  }
}
