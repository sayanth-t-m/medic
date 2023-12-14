import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_scanner/components/utils.dart';
import 'package:ocr_scanner/screens/crop_screen.dart';
import 'package:ocr_scanner/screens/output_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class OCRservice {
  Future<void> takePhoto(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final newImg = await pickedFile.readAsBytes();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CropScreen(image: newImg)));
    } else {
      showSnackBar(context: context, content: 'No image selected');
    }
  }

  Future<void> getPhoto(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final newImg = await pickedFile.readAsBytes();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CropScreen(image: newImg)));
    } else {
      showSnackBar(context: context, content: 'No image selected');
    }
  }

  void cropping(BuildContext context, Uint8List image) {
    try {
      String fileName = 'temp.png';
      final tempDir = Directory.systemTemp;
      final tempPath = tempDir.path;

      final tempFile = File('$tempPath/$fileName');
      tempFile.writeAsBytesSync(image);
      _scanImage(context, tempFile.path);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> _scanImage(BuildContext context, String path) async {
    try {
      final inputImage = InputImage.fromFilePath(path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognisedText =
          await textRecognizer.processImage(inputImage);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => OutputScreen(
                    outputText: recognisedText.text,
                  )),
          (Route<dynamic> route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> exportPDF(BuildContext context, String text) async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Text(text),
          ),
        ),
      );
      String name = 'Output.pdf';
      final fileDir = await getDownloadsDirectory();
      final appDir = Directory('${fileDir?.path}/OCR-Scanner');

      if (!appDir.existsSync()) {
        appDir.createSync(recursive: true);
      }

      final file = File('${appDir.path}/$name');
      await file.writeAsBytes(await pdf.save());
      showSnackBar(context: context, content: 'Pdf exported successfully.');
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
