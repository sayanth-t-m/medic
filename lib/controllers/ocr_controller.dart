import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ocr_scanner/services/ocr_service.dart';

class OCRcontroller {
  final OCRservice ocRservice = OCRservice();

  void takePhoto(BuildContext context) {
    ocRservice.takePhoto(context);
  }

  void getPhoto(BuildContext context) {
    ocRservice.getPhoto(context);
  }

  void cropImage(BuildContext context, Uint8List image) {
    ocRservice.cropping(context, image);
  }

  void exportPdf(BuildContext context, String text) {
    ocRservice.exportPDF(context, text);
  }
}
