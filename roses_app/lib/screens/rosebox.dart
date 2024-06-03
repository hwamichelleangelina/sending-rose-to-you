import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoseBoxScreen extends StatefulWidget {
  const RoseBoxScreen({super.key});

  @override
  _RoseBoxScreenState createState() => _RoseBoxScreenState();
}

class _RoseBoxScreenState extends State<RoseBoxScreen> {
  late Future<List<Rose>> _roses;

  @override
  void initState() {
    super.initState();
    _roses = _fetchRoses();
  }

  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<List<Rose>> _fetchRoses() async {
    final username = await _getUsername();
    if (username == null) {
      throw Exception("Username not found in shared preferences.");
    }
    const baseUrl = 'http://localhost:5000';

    final response = await http.get(Uri.parse('$baseUrl/roses/my-roses/$username'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Periksa apakah 'roses' ada dan merupakan sebuah list
      if (data.containsKey('roses') && data['roses'] is List) {
        return (data['roses'] as List).map((item) => Rose.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Failed to load roses');
    }
  }

  Widget _buildRoseTile(String color, String title, String imagePath, String description) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 190,
        height: 270,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Image.asset(imagePath, height: 120),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RoseBox', style: TextStyle(fontSize: 18)),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "Love is like roses—it makes your battle with thorns seem worthy.",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Rose>>(
                    future: _roses,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No roses found'));
                      } else {
                        final rosesByMonth = _groupRosesByMonth(snapshot.data!);
                        return ListView(
                          children: rosesByMonth.entries.map((entry) {
                            final month = entry.key;
                            final roses = entry.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    DateFormat.yMMMM().format(month),
                                    style: const TextStyle(fontSize: 24, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 270,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: roses.map((rose) {
                                      return _buildRoseTile(
                                        rose.rosecolor,
                                        DateFormat.yMMMMd().format(rose.timestamp),
                                        'assets/images/${rose.rosecolor.toLowerCase()}-rose-icon.png',
                                        '${rose.jumlahmawar} ${rose.rosecolor.toLowerCase()} roses for you. Sent by ${rose.sender}',
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<Rose>> _groupRosesByMonth(List<Rose> roses) {
    final Map<DateTime, List<Rose>> rosesByMonth = {};
    for (var rose in roses) {
      final month = DateTime(rose.timestamp.year, rose.timestamp.month);
      if (rosesByMonth.containsKey(month)) {
        rosesByMonth[month]!.add(rose);
      } else {
        rosesByMonth[month] = [rose];
      }
    }
    return rosesByMonth;
  }
}

class Rose {
  final String rosecolor;
  final String sender;
  final DateTime timestamp;
  final int jumlahmawar;

  Rose({required this.rosecolor, required this.sender, required this.timestamp, required this.jumlahmawar});

  factory Rose.fromJson(Map<String, dynamic> json) {
    return Rose(
      rosecolor: json['rosecolor'],
      sender: json['sender'],
      timestamp: DateTime.parse(json['timestamp']),
      jumlahmawar: json['jumlahmawar'],
    );
  }
}
