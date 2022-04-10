import 'package:flutter/material.dart';

Widget inventory() {
  return Row(
    children: [
      const SizedBox(width: 10.0),
      SizedBox(
        width: 32.0,
        height: 32.0,
        child: Image.asset(
          "assets/images/core/utils/coin.png",
        ),
      ),
      const SizedBox(width: 10.0),
      const Text("1",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.red,
            fontFamily: 'skullsandcrossbones',
          )),
      const SizedBox(width: 30.0),
      SizedBox(
        width: 48.0,
        height: 48.0,
        child: Image.asset(
          "assets/images/core/utils/bait.png",
        ),
      ),
      const SizedBox(width: 10.0),
      const Text("1",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.red,
            fontFamily: 'skullsandcrossbones',
          )),
      const SizedBox(width: 30.0),
      const SizedBox(
        width: 32.0,
        height: 32.0,
        child: Text(
          "XP",
          style: TextStyle(
            color: Colors.red,
            fontSize: 24.0,
          ),
        ),
      ),
      const SizedBox(width: 10.0),
      const Text("1",
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.red,
            fontFamily: 'skullsandcrossbones',
          )),
    ],
  );
}
