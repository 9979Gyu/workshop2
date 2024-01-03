// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:image_picker/image_picker.dart';
//
// class DetectImagePage extends StatefulWidget {
//   const DetectImagePage({Key? key}) : super(key: key);
//
//   @override
//   State<DetectImagePage> createState() => _DetectImagePageState();
// }
//
// class _DetectImagePageState extends State<DetectImagePage> {
//   Color myCustomColor = const Color(0xFF00008B);
//   Color myTextColor = const Color(0xF6F5F5FF);
//
//   bool imageLabelChecking = false;
//   XFile? imageFile;
//   String imageLabel = "";
//
//   Future<String> getModelPath(String asset) async {
//     final path = '${(await getApplicationSupportDirectory()).path}/$asset';
//     await Directory(dirname(path)).create(recursive: true);
//     final file = File(path);
//     if (!await file.exists()) {
//       final byteData = await rootBundle.load(asset);
//       await file.writeAsBytes(byteData.buffer
//           .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//     }
//     return file.path;
//   }
//
//   Future<void> getImageLabels(XFile? image) async {
//     if (image == null) return;
//
//     final labelTflite = await rootBundle.loadString('assets/ml/labels.txt');
//     final labelList = labelTflite.split('\n');
//
//     final modelPath = await getModelPath('assets/ml/model.tflite');
//     final options = LocalLabelerOptions(
//       confidenceThreshold: 0.75,
//       modelPath: modelPath,
//     );
//
//     final imageLabeler = ImageLabeler(options: options);
//     final inputImage = InputImage.fromFilePath(image.path);
//     final labels = await imageLabeler.processImage(inputImage);
//
//     StringBuffer buffer = StringBuffer();
//     for (final imgLabel in labels) {
//       String lblText = labelList[imgLabel.index];
//       double confidence = imgLabel.confidence;
//       buffer.write(lblText);
//       buffer.write(" : ");
//       buffer.write((confidence * 100).toStringAsFixed(2));
//       buffer.write("%\n");
//     }
//     imageLabeler.close();
//
//     setState(() {
//       imageLabel = buffer.toString();
//       imageLabelChecking = false;
//     });
//   }
//
//   void getImage(ImageSource source) async {
//     try {
//       final pickedImage = await ImagePicker().pickImage(source: source);
//       if (pickedImage != null) {
//         setState(() {
//           imageLabelChecking = true;
//           imageFile = pickedImage;
//         });
//         getImageLabels(pickedImage);
//       }
//     } catch (e) {
//       setState(() {
//         imageLabelChecking = false;
//         imageFile = null;
//         imageLabel = "Error occurred while getting image Label";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.indigo[900],
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//           "Image Labeler",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.indigo[900],
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               if (imageLabelChecking) const CircularProgressIndicator(),
//               if (!imageLabelChecking && imageFile == null)
//                 Container(
//                   width: 300,
//                   height: 300,
//                   color: Colors.indigo[300],
//                 ),
//               if (imageFile != null) Image.file(File(imageFile!.path)),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     padding: const EdgeInsets.symmetric(vertical: 20),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepOrangeAccent,
//                         elevation: 10,
//                         shape: const StadiumBorder(),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.image,
//                             size: 30,
//                             color: myTextColor,
//                           ),
//                           Text(
//                             "Gallery",
//                             style: TextStyle(
//                               color: myTextColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       onPressed: () {
//                         getImage(ImageSource.gallery);
//                       },
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     padding: const EdgeInsets.symmetric(vertical: 20),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepOrangeAccent,
//                         elevation: 10,
//                         shape: const StadiumBorder(),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.camera_alt,
//                             size: 30,
//                             color: myTextColor,
//                           ),
//                           Text(
//                             "Camera",
//                             style: TextStyle(
//                               color: myTextColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       onPressed: () {
//                         getImage(ImageSource.camera);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20,),
//               Text(
//                 imageLabel,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   color: Color(0xF6F5F5FF),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
