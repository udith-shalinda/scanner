import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  File _image;
  final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
  final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
  
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    print(image.path);
    setState(() {
      _image = image;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}