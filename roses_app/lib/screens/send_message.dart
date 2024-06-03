// ignore_for_file: library_private_types_in_public_api, unused_field, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:roses_app/widget/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendMessageScreen extends StatefulWidget {
  const SendMessageScreen({super.key});

  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final _formKey = GlobalKey<FormState>();
  var _receiver = '';
  var _message = '';
  var _sender = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sender = prefs.getString('username') ?? '';
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final messageData = {
        'sender': _sender,
        'receiver': _receiver,
        'message': _message,
      };

      final response = await http.post(
        Uri.parse('http://localhost:5000/messages/send-message'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(messageData),
      );

      if (response.statusCode == 201) {
        // Pesan berhasil dikirim
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent successfully')),
        );
        Navigator.of(context).pushNamed('/home');;
      } else {
        // Gagal mengirim pesan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send a Message', style: TextStyle(fontSize: 18)),
        backgroundColor: const Color.fromARGB(255, 54, 7, 30),
      ),
      body: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 54, 7, 30),
                    Color.fromARGB(255, 63, 0, 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20),
                          Padding(
                            padding: screenWidth >= 1100
                                ? const EdgeInsets.symmetric(horizontal: 290)
                                : const EdgeInsets.symmetric(horizontal: 70),
                            child: Image.asset(
                              "assets/images/header.png",
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: screenWidth >= 600
                                ? const EdgeInsets.symmetric(horizontal: 70)
                                : const EdgeInsets.symmetric(horizontal: 20),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Dear,',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: screenWidth >= 600
                                ? const EdgeInsets.symmetric(horizontal: 50)
                                : const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: '',
                                ),
                                onSaved: (value) {
                                  _receiver = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a receiver';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          Padding(
                            padding: screenWidth >= 600
                                ? const EdgeInsets.symmetric(horizontal: 70)
                                : const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: TextFormField(
                                maxLength: 5000,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText: 'Planting a garden of roses will require you to deal with the thorns. Are you ready for the adventure that comes before you get to touch the flowers?',
                                  border: InputBorder.none,
                                ),
                                onSaved: (value) {
                                  _message = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a message';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: screenWidth >= 600
                                ? const EdgeInsets.symmetric(horizontal: 50)
                                : const EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                minimumSize: const Size(250, 50),
                              ),
                              child: const Text(
                                'Send',
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          const Footer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
