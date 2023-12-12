import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:ocr_scanner/controllers/ocr_controller.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key, required this.image});
  final Uint8List image;

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  final CropController _controller = CropController();
  final ocrController = OCRcontroller();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Crop Image'),
      ),
      body: buildcrop(context, widget.image),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).colorScheme.inversePrimary,
          child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      setState(() {
                        isLoading = true;
                      });
                      _controller.crop();
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
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
