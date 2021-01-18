import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scansmart/pages/result_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DateTime currentBackPressTime;

   File imageFile;
   
   bool isLoading = false;

   String result = '';

   Future getImage({bool isGalery}) async {
     setState(() {
     isLoading = true; 
    });
    final pickedFile = await ImagePicker().getImage(source: isGalery? ImageSource.gallery : ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _cropImage(pickedFile.path);
      } else {
        print('No image selected.');
       isLoading = false; 
      }
    });
  }

   Future<Null> _cropImage(String path) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Color(0xff171722),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      setState(() {
       imageFile = croppedFile; 
      });
    }
    else {
      setState(() {
     isLoading = false; 
    });
    }
    readText();

  }

  
  Future readText() async {
    result = '';
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(imageFile);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          result = result + word.text +' ';
        }
      }
    }
    print(result);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen(image: imageFile, result: result,)));
    setState(() {
     isLoading = false; 
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Scan Text'),
        backgroundColor: Color(0xff171722),
        centerTitle: true,
      ),
      body: isLoading? Center(
        child: CircularProgressIndicator(),
      ) : WillPopScope(
        onWillPop: onWillPop,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 70,
                child: RaisedButton(
                  elevation: 7,
                  color: Color(0xff171722),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  onPressed: (){
                    getImage(isGalery: true);
                  },
                  child: Text('Pick From Galery', style: TextStyle(color: Colors.white),),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: 150,
                height: 70,
                child: RaisedButton(
                  elevation: 7,
                  color: Color(0xff171722),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  onPressed: (){
                    getImage(isGalery: false);
                  },
                  child: Text('Pick From Camera', style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

    Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'tekan sekali lagi untuk keluar', backgroundColor: Color(0xff171722), textColor: Colors.white);
      return Future.value(false);
    }
    return Future.value(true);
  }
}