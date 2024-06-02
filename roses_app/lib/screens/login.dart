// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:roses_app/widget/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _username = '';
  var _password = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Proses login, dan jika berhasil, simpan informasi pengguna ke SharedPreferences
      _saveUserInfo(_username);
      // Navigasi ke halaman utama
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _saveUserInfo(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
        child: Container(
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
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
              LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 610) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding (
                        padding: const EdgeInsets.fromLTRB(130, 20, 50, 20),
                        child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropShadow(
                            blurRadius: 10.0,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            opacity: 0.5,
                            offset: const Offset(5.0, 10.0),
                            child: Image.asset(
                              "assets/images/logo.png",
                              width: screenWidth / 4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Image.asset(
                            "assets/images/name.png",
                            width: screenWidth / 4,
                          ),
                        ],
                      ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'LOGIN USER',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 28),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                ),
                                onSaved: (value) {
                                  _username = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a username';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                ),
                                obscureText: true,
                                onSaved: (value) {
                                  _password = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 5) {
                                    return 'Password must be at least 5 characters long';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 40),
                              SizedBox(
                                height: 50,
                                width: 170,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      _submit();
                                    }
                                  },
                                  child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      DropShadow(
                        blurRadius: 10.0,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        opacity: 0.5,
                        offset: const Offset(5.0, 10.0),
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: screenWidth / 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        "assets/images/name.png",
                        width: screenWidth / 2,
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'LOGIN USER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Username'),
                          onSaved: (value) {
                            _username = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          onSaved: (value) {
                            _password = value!;
                          },
                          validator: (value) {
                            if (value!.isEmpty || value.length < 5) {
                              return 'Password must be at least 5 characters long';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 50,
                        width: 170,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _submit();
                            }
                          },
                          child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 120),
            const Footer(),
              ]
            )
          ),
        ),
        
      ),
          ),
        ]
      ),
    );
  }
}
