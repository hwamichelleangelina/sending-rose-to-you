// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SendRoseScreen extends StatefulWidget {
  const SendRoseScreen({super.key});

  @override
  _SendRoseScreenState createState() => _SendRoseScreenState();
}

class _SendRoseScreenState extends State<SendRoseScreen> {
  final _formKey = GlobalKey<FormState>();
  var _receiver = '';
  var _roseCount = 0;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Logic untuk mengirim mawar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Roses'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCCCCFF), Color(0xFF9999CC)], // Gradasi warna periwinkle
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Receiver'),
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
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Number of Roses'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _roseCount = int.parse(value!);
                  },
                  validator: (value) {
                    if (value!.isEmpty || int.parse(value) > 10) {
                      return 'Please enter a number up to 10';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
