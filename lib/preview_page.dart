import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PreviewPage extends StatefulWidget {
  late XFile photo;
  PreviewPage({super.key, required this.photo});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Page"),
      ),
      body: Center(
        child: Image.file(File(widget.photo.path)),
      ),
    );
  }
}