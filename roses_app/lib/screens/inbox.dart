import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Inbox', style: TextStyle(fontSize: 18)), backgroundColor: const Color.fromARGB(255, 63,0,0),),
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
                ),
              ),
SingleChildScrollView(
  child: Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: const Column(
            children: <Widget>[
              SizedBox(height: 20),Text(
            'Inbox',
            style: TextStyle(fontSize: 24, color: Colors.white),),
            ]
          ),
        ),
      ),],),),
          ],),
    ),);
  }
}
