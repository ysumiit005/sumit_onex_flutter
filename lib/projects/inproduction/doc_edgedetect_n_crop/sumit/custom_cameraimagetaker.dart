import 'dart:async';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'custom_cropper_fromimagefile.dart';
// import 'sumit_run_model_by_image_demo.dart';

// A screen that allows users to take a picture using a given camera.
class CustomCameraImageTaker extends StatefulWidget {
  const CustomCameraImageTaker({Key? key}) : super(key: key);

  @override
  CustomCameraImageTakerState createState() => CustomCameraImageTakerState();
}

class CustomCameraImageTakerState extends State<CustomCameraImageTaker> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image
  late ModelObjectDetection _objectModelYoloV8;
  List<ResultObjectDetection?> objDetect = [];
  late final Timer _timer;

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    controller!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("sumit ====> check didchanged ");
  }

//
// auto capture functinality offee
//
  Timer scheduleTimeout() {
    _timer = Timer(const Duration(seconds: 100), handleTimeout);
    return _timer;
  }

  void handleTimeout() async {
    // callback function
    // Do some work.
    // take pic after 10 se
    try {
      if (controller != null) {
        //check if contrller is not null
        if (controller!.value.isInitialized) {
          //check if controller is initialized
          image = await controller!.takePicture(); //capture image
          // setState(() {
          //   //update UI
          // });;

          // File file = File(image!.path);
          // Uint8List imageData = await image!.readAsBytes();

          // send image forward for processing
          // await Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => SumitRunModelByImageDemo(
          //       // Pass the automatically generated path to
          //       // the DisplayPictureScreen widget.
          //       sumitForwardXFile: image,
          //     ),
          //   ),
          // );
          runObjectDetectionYoloV8(image);
        }
      }
    } catch (e) {
      print(e); //show error
    }
  }

  //
  // ends
  //

  loadCamera() async {
    // cameras = await availableCameras();
    if (cameras == null) {
      // solve camera for tab
      try {
        cameras = await availableCameras();
        // cameras = [CameraDescription(name: '', lensDirection: CameraLensDirection.back, sensorOrientation: 1),CameraDescription(name: '', lensDirection: CameraLensDirection.front, sensorOrientation: 0),];
        print(cameras);
      } catch (e) {
        List<CameraDescription> list = [];
        const MethodChannel _channel =
            MethodChannel('plugins.flutter.io/camera_android');
        final List<Map<dynamic, dynamic>>? cameraList = await _channel
            .invokeListMethod<Map<dynamic, dynamic>>('availableCameras');
        print(_channel);
        print(cameraList![0]);
        print(cameraList);
        print(cameraList[1]);
        try {
          for (int i = 0; i < cameraList.length - 1; i++) {
            CameraDescription cameraDescription = CameraDescription(
                name: cameraList[i]['name'],
                lensDirection: cameraList[i]['lensFacing'] == 'back'
                    ? CameraLensDirection.back
                    : CameraLensDirection.front,
                sensorOrientation: cameraList[i]['sensorOrientation']);
            list.add(cameraDescription);
          }
          cameras = list;
        } catch (e) {
          print(e);
        }
      }
      //ends
      controller = CameraController(cameras![0], ResolutionPreset.max,
          enableAudio: false);
      //cameras[0] = first camera, change to 1 to another camera
      print("sumit ====> 1 starting focus");
      // controller!.setFocusMode(FocusMode.auto);

      print("sumit ====> 2 focus done");
      // controller!.prepareForVideoRecording();
      controller!.initialize().then((_) {
        //load models
        loadModel();
        // take pic after 10 sec
        scheduleTimeout();

        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("No any camera found");
    }
  }

  Future loadModel() async {
    String pathImageModel =
        "assets/models/lowprecision_smallsize_lowinference.torchscript.pt";
    //String pathCustomModel = "assets/models/custom_model.ptl";
    // ignore: unused_local_variable
    String pathObjectDetectionModel = "assets/models/yolov5s.torchscript";
    // ignore: unused_local_variable
    String pathObjectDetectionModelYolov8 = "assets/models/yolov8s.torchscript";
    try {
      // _imageModel = await PytorchLite.loadClassificationModel(
      //     pathImageModel, 224, 224, 1000,
      //     labelPath: "assets/labels/label_classification_imageNet.txt");
      //_customModel = await PytorchLite.loadCustomModel(pathCustomModel);
      // _objectModel = await PytorchLite.loadObjectDetectionModel(
      //     pathObjectDetectionModel, 80, 640, 640,
      //     labelPath: "assets/labels/labels_objectDetection_Coco.txt");
      print("hr;;oprojgpeorojg");
      _objectModelYoloV8 = await PytorchLite.loadObjectDetectionModel(
          pathImageModel, 1, 640, 640,
          labelPath:
              "assets/labels/offe_docs_model_138docs_27_september_2023_16_09.txt",
          objectDetectionModelType: ObjectDetectionModelType.yolov8);
      print("hr;;oprojgpeorojg");
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  Future runObjectDetectionYoloV8(XFile? sumitForwardXFile) async {
    //pick a random image
    // print("sumit ok =====> get what we get ${sumitForwardXFile?.path}");
    final XFile? image = sumitForwardXFile;
    Stopwatch stopwatch = Stopwatch()..start();

    objDetect = await _objectModelYoloV8.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.5,
        iOUThreshold: 0.5);
    // textToShow = inferenceTimeAsString(stopwatch);

    print('object executed in ${stopwatch.elapsed.inMilliseconds} ms');
    for (var element in objDetect) {
      print({
        "this ok score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    }

    //
    // sumit - send image to crop screen after detction
    //
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CustomImageCropperFromImageFile(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            detectedImage: image,
            getDetectedObj: objDetect.first!.rect,
          ),
        ),
      );
    }

    // setState(() {
    //   //this.objDetect = objDetect;
    //   _image = File(image.path);
    // });
  }

  //
  // function to take picture
  //
  void takePictureAfterSomeSec() async {}

  //
  // code to focus camera for better image based on user tap
  FocusMode currentFocusMode =
      FocusMode.auto; // Initialize with auto focus mode

  void toggleFocusMode() async {
    print("===> changing focusmode started");

    await controller!.setFocusMode(FocusMode.auto);
    setState(() async {
      // controller!.setZoomLevel(0.0);
      // await controller!.setExposureMode(ExposureMode.auto);
      // controller!.setExposureMode(ExposureMode.locked);
      await controller!.setFocusMode(FocusMode.auto);
      controller!.setFocusMode(FocusMode.locked);
      controller!.setExposureOffset(-0.5);
    });

    print("===> changing focusmode ended");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Camera Preview"),
        backgroundColor: Colors.redAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(children: [
          controller == null
              ? const Center(child: Text("Loading Camera..."))
              : !controller!.value.isInitialized
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : FittedBox(
                      fit: BoxFit.fitWidth,
                      child: GestureDetector(
                        onTap:
                            toggleFocusMode, // Call the toggleFocusMode function on tap
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          // height: 100,
                          child: CameraPreview(
                            controller!,
                          ),
                        ),
                      ),
                    ),
          // Container(
          //   //show captured image
          //   padding: const EdgeInsets.all(30),
          //   child: image == null
          //       ? const Text("No image captured")
          //       : Image.file(
          //           File(image!.path),
          //           // height: 300,
          //         ),
          //   //display captured image
          // )
        ]),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FloatingActionButton(
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          backgroundColor: Colors.red,
          tooltip: "Click to Capture Document",
          onPressed: () async {
            try {
              _timer.cancel();
              if (controller != null) {
                //check if contrller is not null
                if (controller!.value.isInitialized) {
                  //check if controller is initialized
                  image = await controller!.takePicture(); //capture image
                  // setState(() {
                  //   //update UI
                  // });;

                  // File file = File(image!.path);
                  // Uint8List imageData = await image!.readAsBytes();

                  // send image forward for processing
                  // await Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => SumitRunModelByImageDemo(
                  //       // Pass the automatically generated path to
                  //       // the DisplayPictureScreen widget.
                  //       sumitForwardXFile: image,
                  //     ),
                  //   ),
                  // );
                  runObjectDetectionYoloV8(image);
                }
              }
            } catch (e) {
              print(e); //show error
            }
          },
          child: const Icon(Icons.camera),
        ),
      ),
    );
  }
}
