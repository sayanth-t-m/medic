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
  late final OCRcontroller _ocRcontroller;
  late final TextEditingController _textController;

  @override
  void initState() {
    _ocRcontroller = OCRcontroller();
    _textController = TextEditingController();
    _textController.text = widget.outputText;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

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
                    ? TextField(
                        controller: _textController,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
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
              child: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false);
                },
                icon: const Icon(Icons.document_scanner),
              ),
            ),
            SizedBox(
              width: size.width * 0.3,
              child: IconButton(
                onPressed: widget.outputText.isEmpty
                    ? null
                    : () {
                        _ocRcontroller.shareOutput(
                            context, _textController.text);
                      },
                icon: const Icon(Icons.share),
              ),
            ),
            SizedBox(
              width: size.width * 0.3,
              child: IconButton(
                onPressed: widget.outputText.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(
                            ClipboardData(text: _textController.text));
                        showSnackBar(context: context, content: 'Copied');
                      },
                icon: const Icon(Icons.copy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
