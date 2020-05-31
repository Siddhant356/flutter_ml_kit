import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(
      MaterialApp(
        home: MLkit(),
      ),
    );

class MLkit extends StatefulWidget {
  @override
  _MLkitState createState() => _MLkitState();
}

class _MLkitState extends State<MLkit> {
  File _image;
  final picker = ImagePicker();
  bool isImageLoader = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      isImageLoader = true;
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(_image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for(TextLine line in block.lines ){
        for( TextElement word in line.elements) {
          print(word.text);
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ML kit testing"),
      ),
      body: Column(
        children: <Widget>[
         isImageLoader ? Center(
            child: Container(
              height: 300,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(image: FileImage(_image), fit: BoxFit.cover)
              ),
            ),
          ) : Container(),
          SizedBox(height: 10,),
          RaisedButton(
            child: Text("Pick an image"),
            onPressed: getImage,
          ),
          SizedBox(height: 10,),
          RaisedButton(
            child: Text("Read Text"),
            onPressed: readText,
          ),
        ],
      ),
    );
  }
}
