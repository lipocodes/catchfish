import 'package:flutter/material.dart';

Widget pulseGenerator() {
  return Stack(
    children: [
      SizedBox(
        height: 150.0,
        width: 200.0,
        child: Image.asset(
          //pixabay.com
          'assets/images/gameBoard/gauge.png',
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
      )
    ],
  );
}
