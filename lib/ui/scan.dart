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
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imageFile;
    });
    print(_image.path);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Column(
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
  void _initializeVision() async {

    // create vision image from that file
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(this._image);
    // create detector index
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

    // find text in image

    final VisionText visionText = await textRecognizer.processImage(visionImage);
    print(visionText);

    // got the pattern from that SO answer: https://stackoverflow.com/questions/16800540/validate-email-address-in-dart
//    String mailPattern =
//        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
//    RegExp regEx = RegExp(mailPattern);
//
//    String mailAddress =
//        "Couldn't find any mail in the foto! Please try again!";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
//        if (regEx.hasMatch(line.text)) {
//          mailAddress = line.text;
          print(line.text);
//        }
      }
    }
  }

}