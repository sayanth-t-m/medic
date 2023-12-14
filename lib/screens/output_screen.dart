import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ocr_scanner/components/utils.dart';
import 'package:ocr_scanner/controllers/ocr_controller.dart';
import 'package:ocr_scanner/screens/home_screen.dart';

class OutputScreen extends StatefulWidget {
  const OutputScreen({super.key, required this.outputText});
  final String outputText;

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  final OCRcontroller ocRcontroller = OCRcontroller();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Scan Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(9.0),
                width: size.width * 0.94,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: widget.outputText.isNotEmpty
                    ? Text(
                        widget.outputText,
                        style: const TextStyle(color: Colors.black),
                      )
                    : const Text(
                        'Could not find any text in image. Try again',
                        style:
                            TextStyle(color: Color.fromARGB(255, 248, 12, 12)),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: size.width * 0.3,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text('Scan')),
            ),
            SizedBox(
              width: size.width * 0.3,
              child: ElevatedButton(
                  onPressed: widget.outputText.isEmpty
                      ? null
                      : () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CircularProgressIndicator();
                              });
                          ocRcontroller.exportPdf(context, widget.outputText);
                          Navigator.pop(context);
                        },
                  child: const Text('Export')),
            ),
            SizedBox(
              width: size.width * 0.3,
              child: ElevatedButton(
                  onPressed: widget.outputText.isEmpty
                      ? null
                      : () {
                          Clipboard.setData(
                              ClipboardData(text: widget.outputText));
                          showSnackBar(context: context, content: 'Copied');
                        },
                  child: const Text('Copy')),
            ),
          ],
        ),
      ),
    );
  }
}
