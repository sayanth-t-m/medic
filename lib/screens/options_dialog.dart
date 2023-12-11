import 'package:flutter/material.dart';
import 'package:ocr_scanner/controllers/ocr_controller.dart';

class OptionsDialog extends StatefulWidget {
  const OptionsDialog({super.key});

  @override
  State<OptionsDialog> createState() => _OptionsDialogState();
}

class _OptionsDialogState extends State<OptionsDialog> {
  final ocrController = OCRcontroller();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Choose an option',
        style: TextStyle(fontSize: 14),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () => _takePhoto(context),
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Camera'),
          ),
          ElevatedButton.icon(
            onPressed: () => _getPhoto(context),
            icon: const Icon(Icons.image_outlined),
            label: const Text('Gallery'),
          ),
        ],
      ),
    );
  }

  void _takePhoto(BuildContext context) {
    ocrController.takePhoto(context);
  }

  void _getPhoto(BuildContext context) {
    ocrController.getPhoto(context);
  }
}
