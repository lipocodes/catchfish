import 'package:flutter/material.dart';

Widget countdown() {
  String minutes = "00";
  String seconds = "00";
  return Text(minutes + ":" + seconds,
      style: const TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
        fontFamily: 'skullsandcrossbones',
      ));
}
