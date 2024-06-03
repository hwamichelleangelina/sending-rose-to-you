// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:roses_app/widget/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Message {
  final String sender;
  final DateTime timestamp;
  final String message;

  Message({
    required this.sender,
    required this.timestamp,
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'] ?? 'Unknown',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      message: json['message'] ?? '',
    );
  }
}

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late Future<List<Message>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = _fetchMessages();
  }

  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<List<Message>> _fetchMessages() async {
    final username = await _getUsername();
    if (username == null) {
      throw Exception('No username found in SharedPreferences');
    }

    const baseUrl = 'http://localhost:5000';

    final response = await http.get(Uri.parse('$baseUrl/messages/my-messages/$username'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['messages'];
      List<Message> messages = body.map((dynamic item) => Message.fromJson(item)).toList();
      return messages;
    } else {
      throw Exception('Failed to load messages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox', style: TextStyle(fontSize: 18)),
        backgroundColor: const Color.fromARGB(255, 54, 7, 30),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 54, 7, 30),
                  Color.fromARGB(255, 63, 0, 0)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          FutureBuilder<List<Message>>(
            future: _messages,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No messages.'));
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: Text(
                        'Roses may wither with time, but the memories and feelings they evoke will last forever. Rose for all the dreamers...',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),),
                      const SizedBox(height: 40),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final message = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                        child: ListTile(
                          title: Text(
                            message.sender,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            DateFormat('d MMMM y HH:mm:ss').format(message.timestamp),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: const Color.fromARGB(255, 54, 7, 30),
                                  title: Text('Message from ${message.sender}', style: const TextStyle(color: Colors.white)),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 10),
                                        Align(alignment: Alignment.topRight, child: Text(DateFormat('d MMMM y HH:mm:ss').format(message.timestamp), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white))),
                                        const SizedBox(height: 30),
                                        Image.asset(
                                          'assets/images/pink-rose.png',
                                          height: 60,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(message.message, style: const TextStyle(color: Colors.white)),
                                        const SizedBox(height: 40),
                                        Text('Sent with love,\n${message.sender}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Close', style: TextStyle(color: Colors.white)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      const Footer(),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

