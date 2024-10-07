// import 'package:camera/camera.dart';
// import 'package:get/get.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:flutter/material.dart';
//
// import '../../../controller/faceController/camera.service.dart';
//
//
//
// class FaceDetectorService extends GetxController{
//   CameraService CameraController = Get.find<CameraService>();
//
//   FaceDetector? _faceDetector;
//   FaceDetector? get faceDetector => _faceDetector;
//   FaceDetectorService(){
//     initialize();
//   }
//   void initialize() {
//     _faceDetector = GoogleMlKit.vision.faceDetector(
//       FaceDetectorOptions(
//         mode: FaceDetectorMode.accurate,
//       ),
//     );
//   }
//
//   Future<List<Face>> getFacesFromImage(CameraImage image) async {
//     InputImageData _firebaseImageMetadata = InputImageData(
//       imageRotation: CameraController.cameraRotation!,
//       inputImageFormat: InputImageFormatMethods.fromRawValue(image.format.raw)!,
//       size: Size(image.width.toDouble(), image.height.toDouble()),
//       planeData: image.planes.map(
//         (Plane plane) {
//           return InputImagePlaneMetadata(
//             bytesPerRow: plane.bytesPerRow,
//             height: plane.height,
//             width: plane.width,
//           );
//         },
//       ).toList(),
//     );
//
//     InputImage _firebaseVisionImage = InputImage.fromBytes(
//       bytes: image.planes[0].bytes,
//       inputImageData: _firebaseImageMetadata,
//     );
//
//     List<Face> faces = await _faceDetector!.processImage(_firebaseVisionImage);
//     return faces;
//   }
//
//   @override
//   dispose() {
//     super.dispose();
//     _faceDetector!.close();
//   }
// }
