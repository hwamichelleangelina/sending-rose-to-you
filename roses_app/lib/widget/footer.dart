import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.0),
          child: Divider(
            color: Color.fromARGB(255,235,185,185),
          ),
        ),


        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          width: double.maxFinite,
          alignment: Alignment.center,
          child: const Text(
            "_fleur d'automne_",
            style: TextStyle(
              fontFamily: 'TheSeasons',
              fontWeight: FontWeight.w400,
              color:  Color.fromARGB(255,235,185,185),
            ),
          ),
        ),
      ],
    );
  }
}