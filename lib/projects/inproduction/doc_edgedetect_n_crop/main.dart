import 'package:flutter/material.dart';
import 'package:sumit_onex_flutter/projects/inproduction/doc_edgedetect_n_crop/sumit/custom_cameraimagetaker.dart';
import 'run_model_by_camera_demo.dart';
import 'run_model_by_image_demo.dart';

Future<void> main() async {
  runApp(const DocEdgeDetectNCrop());
}

class DocEdgeDetectNCrop extends StatefulWidget {
  const DocEdgeDetectNCrop({Key? key}) : super(key: key);

  @override
  State<DocEdgeDetectNCrop> createState() => DocEdgeDetectNCropState();
}

class DocEdgeDetectNCropState extends State<DocEdgeDetectNCrop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sumit Onex EdgeDetection N Crop Using PytorcLite'),
      ),
      body: Builder(builder: (context) {
        return Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CustomCameraImageTaker()),
                  )
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Sumit Onex - Edge Detection and Cropping",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RunModelByCameraDemo()),
                  )
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Run Model with Camera",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RunModelByImageDemo()),
                  )
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Run Model with Image",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
