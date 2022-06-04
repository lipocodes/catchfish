import 'package:flutter/material.dart';

Widget countdown(BuildContext context, String newCountdownTime) {
  return gui(newCountdownTime);
}

Widget gui(String currentTime) {
  return Text(currentTime,
      style: const TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
        fontFamily: 'skullsandcrossbones',
      ));
}
