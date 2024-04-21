import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  List<Reminder> reminders = []; // List to store reminders

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.outputText);
    outputText = widget.outputText;

    // Initialize notification plugin settings
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();

    if (widget.outputText.isNotEmpty) {
      // You can call fetchOutput here if needed
    }
    speakText(outputText); // Speak text on load if available
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> speakText(String text) async {
    await flutterTts.setVolume(1.0); // Set volume to 100% (1.0)
    await flutterTts.setSpeechRate(1.0); // Set speech rate to normal (1.0)
    await flutterTts.setPitch(1.0); // Set pitch to normal (1.0)
    await flutterTts.speak(text);
  }

  Future<void> scheduleReminder(Reminder reminder) async {
    // Replace with your reminder scheduling logic using flutter_local_notifications
    // This is just a placeholder
    setState(() {
      reminders.add(reminder); // Add reminder to the list
    });
  }

  Future<void> deleteReminder(Reminder reminder) async {
    // Replace with your reminder deletion logic using flutter_local_notifications
    // This is just a placeholder
    setState(() {
      reminders.remove(reminder); // Remove reminder from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900], // Adjust app bar color
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
                  borderRadius: BorderRadius.circular(10),
                  // Adjust border radius
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
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
                  ? Column(
                      children: [
                        Text(
                          'Output: $outputText',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reminders:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: reminders.length,
                              itemBuilder: (context, index) {
                                final reminder = reminders[index];
                                return ListTile(
                                  title: Text(reminder.text),
                                  subtitle: Text(reminder.time.toString()),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    color:
                                        Colors.red, // Adjust delete icon color
                                    onPressed: () {
                                      deleteReminder(reminder);
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _showReminderDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey[
                                    900], // Adjust button background color
                              ),
                              child: Text(
                                'Add Reminder',
                                style: TextStyle(
                                    color: Colors.white), // Adjust text color
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          speakText(outputText);
        },
        backgroundColor: Colors.blueGrey[900], // Adjust FAB color
        child: Icon(Icons.volume_up),
      ),
    );
  }

  Future<void> _showReminderDialog(BuildContext context) async {
    String reminderText = '';
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  reminderText = value;
                },
                decoration: InputDecoration(labelText: 'Reminder Text'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      selectedTime = time;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blueGrey[900], // Adjust button background color
                ),
                child: Text(
                  selectedTime != null
                      ? 'Selected Time: ${selectedTime!.hour}:${selectedTime!.minute}'
                      : 'Select Time',
                  style: TextStyle(color: Colors.white), // Adjust text color
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (reminderText.isNotEmpty && selectedTime != null) {
                  final reminder = Reminder(
                    text: reminderText,
                    time: selectedTime!,
                  );
                  scheduleReminder(reminder);
                  Navigator.of(context).pop();
                } else {
                  // Show error message if reminder text or time is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter reminder text and select time.',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blueGrey[900], // Adjust button background color
              ),
              child: Text(
                'Add',
                style: TextStyle(color: Colors.white), // Adjust text color
              ),
            ),
          ],
        );
      },
    );
  }
}

class Reminder {
  final String text;
  final TimeOfDay time;

  Reminder({required this.text, required this.time});
}
