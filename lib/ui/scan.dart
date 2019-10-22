import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';



bool useFlutterImageCompress = true;
bool keepExif = true;
bool autoCorrectionAngle = true;


class Scan extends StatefulWidget {

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  File _image;


  Future getImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = imageFile;
    });
    print(_image.path);
    // _initializeVision();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: ListView(
        children: <Widget>[
          _image == null
              ? Text('No image selected.')
              : Image.file(_image),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _initializeVision,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
  Future _initializeVision() async {

    // create vision image from that file
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(this._image);
    // create detector index
    // final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    // final VisionText visionText = await textRecognizer.processImage(visionImage);
    // print(visionText);
    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();   
    final List<ImageLabel> labels = await labeler.processImage(visionImage); 


    for (ImageLabel label in labels) {
      final String text = label.text;
      final String entityId = label.entityId;
      final double confidence = label.confidence;
      print(text);
    }
    labeler.close();

    // got the pattern from that SO answer: https://stackoverflow.com/questions/16800540/validate-email-address-in-dart
//    String mailPattern =
//        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
//    RegExp regEx = RegExp(mailPattern);
//
//    String mailAddress =
//        "Couldn't find any mail in the foto! Please try again!";
//     for (TextBlock block in visionText.blocks) {
//       for (TextLine line in block.lines) {
// //        if (regEx.hasMatch(line.text)) {
// //          mailAddress = line.text;
//           print(line.text);
// //        }
//       }
  //   }
  }

}