import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:prototype/screens/resultScreen.dart';

import '../nav/forum.dart';

class ChatScreens extends StatefulWidget {
  const ChatScreens({Key? key}) : super(key: key);

  @override
  State<ChatScreens> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreens> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();

  void sendMessage() async {
    final text = controller.text.trim();
    final endChat = "goodbye";

    if (text.isEmpty) return;

    if (text.contains(endChat))  {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            summary: "You mentioned feeling overwhelmed and distracted.",
            possibleConditions: ["ADHD", "Mild Anxiety"],
            recommendation: "Consider speaking with a mental health professional. Meanwhile, try focusing exercises or journaling daily.",
            scores: {
              "Sleep": 2.0,
              "Appetite": 1.5,
              "Energy": 3.0,
              "Concentration": 2.5,
              "Interest": 2.0,
              "Self-Esteem": 1.0,
              "Suicidal Thoughts": 0.0,
            },
          ),
        ),
      );
    }

    setState(() {
      messages.add({'role': 'user', 'text': text});
    });

    controller.clear();

    final botReply = await fetchOpenAIResponse(text);

    setState(() {
      messages.add({'role': 'bot', 'text': botReply});
    });
  }

  Future<String> fetchOpenAIResponse(String prompt) async {
    final apiKey = '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'; // use any AI KEY HERE
// Build the conversation history for the API
    final apiMessages = [
      {
        "role": "system",
        "content": "You are a helpful mental health assistant. Ask the user questions to screen for common neurological disorders such as ADHD, depression, anxiety, and autism. Ask one question at a time, do not repeat the same question, and adjust based on user answers."
      },
      // Add all previous chat messages
      ...messages.map((m) => {
        "role": m['role']!,
        "content": m['text']!,
      }),
      // Add the current user message
      {
        "role": "user",
        "content": prompt
      }
    ];

    final response = await http.post(
      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "google/gemini-2.5-flash",
        "max_tokens": 500,
        "messages": apiMessages
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      print("OpenRouter API error: ${response.body}");
      return "Sorry, I couldn’t respond right now.";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Neuro Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final msg = messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.teal[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: "Type your answer..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
