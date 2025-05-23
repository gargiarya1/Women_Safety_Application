import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final FlutterTts tts = FlutterTts();
  final TextEditingController controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  // Initialize the Text-to-Speech (TTS) engine
  void initTTS() async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
  }

  // Speak the response text using Text-to-Speech
  void speak(String text) async {
    await tts.speak(text);
  }

  // Build the prompt for OpenAI's GPT
  String buildPrompt(String input) {
    return '''You are BSafe's AI Assistant. Answer user questions clearly.
BSafe is a women's safety app that can:
- Send SOS messages to contacts.
- Share real-time location.
- Add emergency contacts.
- Use voice commands.

User: $input
Assistant:''';
  }

  // Function to send message and get a response from OpenAI
  Future<String> fetchResponse(String prompt) async {
    final String apiKey = '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'; // Replace with your OpenAI API key
    final url = Uri.parse('https://api.openai.com/v1/completions');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'text-davinci-003', // You can use a different model if needed
          'prompt': prompt,
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['text'].toString();
      } else {
        // If the API call fails
        print('API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return 'Sorry, I couldn\'t get a response.';
      }
    } catch (e) {
      // Handle any exceptions or network errors
      print('Error: $e');
      return 'Sorry, I couldn\'t get a response.';
    }
  }

  // Function to handle sending a message and getting a response
  void sendMessage(String input) async {
    if (input.trim().isEmpty) return;

    setState(() {
      messages.add({"user": input});
      isLoading = true;
    });

    // Call the API to get a real response
    String response = await fetchResponse(buildPrompt(input));

    setState(() {
      messages.add({"bot": response});
      isLoading = false;
    });

    // Speak the response using Text-to-Speech
    speak(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BSafe AI Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final entry = messages[index];
                final isUser = entry.containsKey("user");
                final text = isUser ? entry["user"]! : entry["bot"]!;
                return ListTile(
                  title: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(text),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isLoading) const LinearProgressIndicator(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: "Ask something..."),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  sendMessage(controller.text);
                  controller.clear();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    tts.stop();
    controller.dispose();
    super.dispose();
  }
}
