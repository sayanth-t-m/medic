import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:ocr_scanner/controllers/ocr_controller.dart';

class CropScreen extends StatelessWidget {
  CropScreen({super.key, required this.image});
  final Uint8List image;
  final CropController _controller = CropController();
  final ocrController = OCRcontroller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Crop Image'),
      ),
      body: buildcrop(context, image),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).colorScheme.inversePrimary,
          child: ElevatedButton(
              onPressed: () {
                _controller.crop();
              },
              child: const Text(
                'Crop',
                style: TextStyle(fontSize: 20),
              ))),
    );
  }

  Widget buildcrop(BuildContext context, Uint8List image) {
    return Crop(
        controller: _controller,
        image: image,
        onCropped: (croppedImage) {
          ocrController.cropImage(context, croppedImage);
        });
  }
}
