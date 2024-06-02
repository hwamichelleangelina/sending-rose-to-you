// HomeScreen.dart
import 'package:flutter/material.dart';
import 'package:roses_app/widget/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserInfo(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final username = snapshot.data;
        return Scaffold(
          body: Scaffold(
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
                  image: DecorationImage(
                    image: AssetImage("assets/images/petal.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                    // Adjust opacity as needed
                  ),
                ),  
              ),
        SingleChildScrollView(
        child: 
        Column(
            children: <Widget>[
              const SizedBox(height: 85),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
              Text(
                'WELCOME, \n$username',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const SizedBox(height:30.0),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Roses are a reminder that even in the midst of thorns and challenges, love and happiness can still bloom.',
                textAlign: TextAlign.center,
              ),),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/inbox');
                },
                  style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  minimumSize: const Size(250, 50),
                ),
                child: const Text('Go to Inbox', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/send-message');
                },
                  style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  minimumSize: const Size(250, 50),
                ),
                child: const Text('Send a Message', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/send-rose');
                },
                  style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  minimumSize: const Size(250, 50),
                ),
                child: const Text('Send Roses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/roses');
                },
                  style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  minimumSize: const Size(250, 50),
                ),
                child: const Text('Go to Roses Collection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

            const SizedBox(height: 110),
            Image.asset(
              "assets/images/red-rose-long.png",
              width: 170,
            ),
            const SizedBox(height: 40),
            const Footer(),
            ],
            
          ),
        ),
            ]
      ),),]
          ),

          ),
        );
      },
    );
  }

  Future<String?> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
