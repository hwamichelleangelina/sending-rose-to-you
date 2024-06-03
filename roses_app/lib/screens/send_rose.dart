// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:roses_app/widget/footer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SendRoseScreen extends StatefulWidget {
  const SendRoseScreen({super.key});

  @override
  _SendRoseScreenState createState() => _SendRoseScreenState();
}

class _SendRoseScreenState extends State<SendRoseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _receiver = '';
  String _sender = '';
  String _rosecolor = '';
  int _jumlahmawar = 1;

  void _submit() {
    if (_formKey.currentState!.validate() && _rosecolor.isNotEmpty) {
      _formKey.currentState!.save();
      // Logic untuk mengirim mawar
      _sendRose();
    }
  }

  void _sendRose() async {
    // Fetch username from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _sender = prefs.getString('username') ?? 'Unknown';

    // Prepare rose data
    final roseData = {
      'sender': _sender,
      'receiver': _receiver,
      'jumlahmawar': _jumlahmawar,
      'rosecolor': _rosecolor,
    };

    // Send rose data to backend
    const baseUrl = 'http://localhost:5000';
    final response = await http.post(
      Uri.parse('$baseUrl/roses/send-rose'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(roseData),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rose sent successfully!')),
      );
    } else {
      final responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? 'Failed to send rose.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $errorMessage')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send a Rose', style: TextStyle(fontSize: 18)),
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
                          const SizedBox(height: 20),
                          // Pilihan warna mawar
                          screenWidth >= 835
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                              _buildRoseTile('Red', 'Red Rose', 'assets/images/red-rose-icon.png', 'for the perfect love, deep passion and your unconcious beauty.'),
                              _buildRoseTile('Pink', 'Pink Rose', 'assets/images/pink-rose-icon.png', 'sweetness, appreciation, and admiration of you.'),
                              _buildRoseTile('Yellow', 'Yellow Rose', 'assets/images/yellow-rose-icon.png', 'for our last long warm and cheerful relationship.'),
                                  ],
                                )
                              : Column(
                                  children: [
                              _buildRoseTile('Red', 'Red Rose', 'assets/images/red-rose-icon.png', 'for the perfect love, deep passion and your unconcious beauty.'),
                              _buildRoseTile('Pink', 'Pink Rose', 'assets/images/pink-rose-icon.png', 'sweetness, appreciation, and admiration of you.'),
                              _buildRoseTile('Yellow', 'Yellow Rose', 'assets/images/yellow-rose-icon.png', 'for our last long warm and cheerful relationship.'),
                                  ],
                                ),
                          const SizedBox(height: 20),
                          // Kontrol jumlah mawar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: Colors.white),
                                onPressed: () {
                                  if (_jumlahmawar > 1) {
                                    setState(() {
                                      _jumlahmawar--;
                                    });
                                  }
                                },
                              ),
                              Text(
                                '$_jumlahmawar',
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  if (_jumlahmawar < 10) {
                                    setState(() {
                                      _jumlahmawar++;
                                    });
                                  }
                                },
                              ),
                            ],
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
                              child: const Text('Send'),
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

  Widget _buildRoseTile(String color, String title, String imagePath, String description) {
    final isSelected = _rosecolor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _rosecolor = color;
        });
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: Colors.white) : null,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Image.asset(imagePath, height: 150),
            const SizedBox(height: 20),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/*
                              _buildRoseTile('Red', 'Red Rose', 'assets/images/red-rose-icon.png', 'for the perfect love, deep passion and your unconcious beauty.'),
                              _buildRoseTile('Pink', 'Pink Rose', 'assets/images/pink-rose-icon.png', 'sweetness, appreciation, and admiration of you.'),
                              _buildRoseTile('Yellow', 'Yellow Rose', 'assets/images/yellow-rose-icon.png', 'for our last long warm and cheerful relationship.'),
*/