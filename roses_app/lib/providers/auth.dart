import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token = '';

  bool get isAuth {
    return _token != '';
  }

  String get token {
    return _token;
  }

  Future<void> register(String name, String username, String password) async {
    const url = 'http://localhost:5000/auth/register';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({'name': name, 'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to register');
    }
  }

  Future<void> login(String username, String password) async {
    const url = 'http://localhost:5000/auth/login';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      _token = responseData['token'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token);
    } else {
      throw Exception('Failed to login');
    }
  }
}
