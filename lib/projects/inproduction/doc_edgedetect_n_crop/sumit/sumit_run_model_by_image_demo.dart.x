import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io';
// import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import '/sumit/custom_cropper_fromimagefile.dart';

class SumitRunModelByImageDemo extends StatefulWidget {
  const SumitRunModelByImageDemo({Key? key, this.sumitForwardXFile})
      : super(key: key);

  final XFile? sumitForwardXFile;

  @override
  _SumitRunModelByImageDemoState createState() =>
      _SumitRunModelByImageDemoState();
}

class _SumitRunModelByImageDemoState extends State<SumitRunModelByImageDemo> {
  ClassificationModel? _imageModel;
  //CustomModel? _customModel;
  // late ModelObjectDetection _objectModel;
  late ModelObjectDetection _objectModelYoloV8;

  String? textToShow;
  List? _prediction;
  File? _image;
  // final ImagePicker _picker = ImagePicker();
  bool objectDetection = false;
  List<ResultObjectDetection?> objDetect = [];
  @override
  void initState() {
    super.initState();
    loadModel().then((value) => runObjectDetectionYoloV8());
  }

  //load your model
  Future loadModel() async {
    String pathImageModel =
        "assets/models/lowprecision_smallsize_lowinference.torchscript.pt";
    //String pathCustomModel = "assets/models/custom_model.ptl";
    String pathObjectDetectionModel = "assets/models/yolov5s.torchscript";
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

  //run an image model
  // Future runObjectDetectionWithoutLabels() async {
  //   //pick a random image
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   Stopwatch stopwatch = Stopwatch()..start();

  //   objDetect = await _objectModel
  //       .getImagePredictionList(await File(image!.path).readAsBytes());
  //   textToShow = inferenceTimeAsString(stopwatch);

  //   for (var element in objDetect) {
  //     print({
  //       "score": element?.score,
  //       "className": element?.className,
  //       "class": element?.classIndex,
  //       "rect": {
  //         "left": element?.rect.left,
  //         "top": element?.rect.top,
  //         "width": element?.rect.width,
  //         "height": element?.rect.height,
  //         "right": element?.rect.right,
  //         "bottom": element?.rect.bottom,
  //       },
  //     });
  //   }
  //   setState(() {
  //     //this.objDetect = objDetect;
  //     _image = File(image.path);
  //   });
  // }

  // Future runObjectDetection() async {
  //   //pick a random image

  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   Stopwatch stopwatch = Stopwatch()..start();
  //   objDetect = await _objectModel.getImagePrediction(
  //       await File(image!.path).readAsBytes(),
  //       minimumScore: 0.1,
  //       iOUThreshold: 0.3);
  //   textToShow = inferenceTimeAsString(stopwatch);
  //   print('object executed in ${stopwatch.elapsed.inMilliseconds} ms');

  //   for (var element in objDetect) {
  //     print({
  //       "score": element?.score,
  //       "className": element?.className,
  //       "class": element?.classIndex,
  //       "rect": {
  //         "left": element?.rect.left,
  //         "top": element?.rect.top,
  //         "width": element?.rect.width,
  //         "height": element?.rect.height,
  //         "right": element?.rect.right,
  //         "bottom": element?.rect.bottom,
  //       },
  //     });
  //   }
  //   setState(() {
  //     //this.objDetect = objDetect;
  //     _image = File(image.path);
  //   });
  // }

  Future runObjectDetectionYoloV8() async {
    //pick a random image
    print("sumit ok =====> get what we get ${widget.sumitForwardXFile?.path}");
    final XFile? image = widget.sumitForwardXFile;
    Stopwatch stopwatch = Stopwatch()..start();

    objDetect = await _objectModelYoloV8.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.5,
        iOUThreshold: 0.5);
    textToShow = inferenceTimeAsString(stopwatch);

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
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CustomImageCropperFromImageFile(
          // Pass the automatically generated path to
          // the DisplayPictureScreen widget.
          detectedImage: image,
          getDetectedObj: objDetect.first!.rect,
        ),
      ),
    );

    setState(() {
      //this.objDetect = objDetect;
      _image = File(image.path);
    });
  }

  String inferenceTimeAsString(Stopwatch stopwatch) =>
      "Inference Took ${stopwatch.elapsed.inMilliseconds} ms";

  // Future runClassification() async {
  //   objDetect = [];
  //   //pick a random image

  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   //get prediction
  //   //labels are 1000 random english words for show purposes
  //   print(image!.path);
  //   Stopwatch stopwatch = Stopwatch()..start();

  //   textToShow = await _imageModel!
  //       .getImagePrediction(await File(image.path).readAsBytes());
  //   textToShow = "${textToShow ?? ""}, ${inferenceTimeAsString(stopwatch)}";

  //   List<double?>? predictionList = await _imageModel!.getImagePredictionList(
  //     await File(image.path).readAsBytes(),
  //   );

  //   print(predictionList);
  //   // List<double?>? predictionListProbabilities =
  //   //     await _imageModel!.getImagePredictionListProbabilities(
  //   //   await File(image.path).readAsBytes(),
  //   // );
  //   // //Gettting the highest Probability
  //   // double maxScoreProbability = double.negativeInfinity;
  //   // double sumOfProbabilities = 0;
  //   // int index = 0;
  //   // for (int i = 0; i < predictionListProbabilities!.length; i++) {
  //   //   if (predictionListProbabilities[i]! > maxScoreProbability) {
  //   //     maxScoreProbability = predictionListProbabilities[i]!;
  //   //     sumOfProbabilities =
  //   //         sumOfProbabilities + predictionListProbabilities[i]!;
  //   //     index = i;
  //   //   }
  //   // }
  //   // print(predictionListProbabilities);
  //   // print(index);
  //   // print(sumOfProbabilities);
  //   // print(maxScoreProbability);
  //   print("sumit =====> get prediction coordinates ===> ");

  //   setState(() {
  //     //this.objDetect = objDetect;
  //     _image = File(image.path);
  //   });
  // }

/*
  //run a custom model with number inputs
  Future runCustomModel() async {
    _prediction = await _customModel!
        .getPrediction([1, 2, 3, 4], [1, 2, 2], DType.float32);

    setState(() {});
  }
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Run model with Image'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: objDetect.isNotEmpty
                  ? _image == null
                      ? const Text('No image selected.')
                      : _objectModelYoloV8.renderBoxesOnImage(
                          _image!, objDetect)
                  : _image == null
                      ? const Text('No image selected.')
                      : Image.file(_image!),
            ),
            Center(
              child: Visibility(
                visible: textToShow != null,
                child: Text(
                  "$textToShow",
                  maxLines: 3,
                ),
              ),
            ),
            /*
            Center(
              child: TextButton(
                onPressed: runImageModel,
                child: Row(
                  children: [

                    Icon(
                      Icons.add_a_photo,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            */

            // TextButton(
            //   onPressed: runClassification,
            //   style: TextButton.styleFrom(
            //     backgroundColor: Colors.blue,
            //   ),
            //   child: const Text(
            //     "Run Classification",
            //     style: TextStyle(
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Run object detection with labels",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: runObjectDetectionYoloV8,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Run object detection YoloV8 with labels",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Run object detection without labels",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Visibility(
                visible: _prediction != null,
                child: Text(_prediction != null ? "${_prediction![0]}" : ""),
              ),
            )
          ],
        ),
      ),
    );
  }
}
