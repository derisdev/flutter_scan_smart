import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PreviewScreen extends StatefulWidget {
  final File image;
  PreviewScreen({this.image});
  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
    child: PhotoView(
      imageProvider: FileImage(widget.image),
    )
  );
  }
}