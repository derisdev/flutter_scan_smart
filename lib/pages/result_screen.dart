import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scansmart/pages/preview_screen.dart';

class ResultScreen extends StatefulWidget {
  final String result;
  final File image;
  ResultScreen({this.image, this.result});
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  TextEditingController resultController = TextEditingController();

  @override
  void initState() {
    setState(() {
      resultController.text = widget.result;
    });
    super.initState();
  }

  @override
  void dispose() {
    resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff171722),
        title: Text('Result'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewScreen(image: widget.image)));
            },
            child: Text('Preview', style: TextStyle(color: Colors.deepOrange)),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10),
        child: TextField(
          textAlign: TextAlign.left,
          style: TextStyle(color: Color(0xff171722), fontSize: 13),
          controller: resultController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              labelText: 'Result',
              labelStyle: TextStyle(fontSize: 13, color: Color(0xffb0aed9)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffb0aed9)),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffb0aed9)))),
        ),
      ),
    );
  }
}
