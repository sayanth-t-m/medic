import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

class OutputScreen extends StatefulWidget {
  const OutputScreen({Key? key, required this.outputText}) : super(key: key);
  final String outputText;

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  late final TextEditingController _textController;
  late String outputText;
  bool isLoading = false;
  String errorMessage = '';
  late final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.outputText);
    outputText = widget.outputText; // Initialize outputText with outputText
    if (widget.outputText.isNotEmpty) {
      fetchOutput(
          widget.outputText); // Call fetchOutput if outputText is not empty
    }
  }

  Future<void> fetchOutput(String inputText) async {
    setState(() {
      isLoading = true;
    });

    final apiKey = "YOUR_API_KEY"; // Replace with your actual API key
    final url =
        "https://generativelanguage.googleapis.com/v1beta/tunedModels/i-medic-mlns4bmks4xt:generateContent?key=$apiKey";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: '''
        {
          "contents": [
            {
              "parts": [
                {"text": "input: $outputText"},
                {"text": "output: $outputText"}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.9,
            "topK": 1,
            "topP": 1,
            "maxOutputTokens": 2048,
            "stopSequences": []
          },
          "safetySettings": [
            {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_NONE"}
          ]
        }
        ''',
      );

      if (response.statusCode == 200) {
        setState(() {
          outputText = response.body; // Update outputText with API response
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch output: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching output: $e');
      setState(() {
        errorMessage = 'Failed to fetch output';
        isLoading = false;
      });
    }
  }

  Future<void> speakText(String text) async {
    await flutterTts.setVolume(1.0); // Set volume to 100% (1.0)
    await flutterTts.setSpeechRate(1.0); // Set speech rate to normal (1.0)
    await flutterTts.setPitch(1.0); // Set pitch to normal (1.0)
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : outputText.isNotEmpty
                        ? TextField(
                            controller: _textController,
                            onChanged: (value) {
                              setState(() {
                                outputText =
                                    value; // Update outputText when text changes
                              });
                            },
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                          )
                        : Text(
                            errorMessage.isNotEmpty
                                ? errorMessage
                                : 'Could not find any text in image. Try again',
                            style: TextStyle(
                              color: errorMessage.isNotEmpty
                                  ? Colors.red
                                  : Color.fromARGB(255, 248, 12, 12),
                            ),
                          ),
              ),
              const SizedBox(height: 20),
              outputText.isNotEmpty
                  ? Text(
                      'Output: $outputText',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  : Container(), // Display output text if available
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          speakText(outputText);
        },
        child: Icon(Icons.volume_up),
      ),
    );
  }
}
