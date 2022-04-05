import 'package:flutter/material.dart';

Widget hereWorking(String screenName) {
  return Center(
    child: Column(
      children: [
        Image.asset("assets/images/working.png"),
        const SizedBox(height: 20.0),
        Text(
          screenName,
          style: const TextStyle(fontSize: 32, color: Colors.blueAccent),
        )
      ],
    ),
  );
}
