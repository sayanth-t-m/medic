import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ocr_scanner/components/utils.dart';
import 'package:ocr_scanner/screens/home_screen.dart';

class OutputScreen extends StatelessWidget {
  const OutputScreen({super.key, required this.outputText});
  final String outputText;

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
                child: Text(
                  outputText,
                  style: const TextStyle(color: Colors.black),
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
              width: size.width * 0.4,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text('Scan again')),
            ),
            SizedBox(
              width: size.width * 0.4,
              child: ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: outputText));
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
