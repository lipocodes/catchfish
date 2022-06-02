import 'package:flutter/material.dart';

Widget pulseGenerator(double angle) {
  return Stack(
    alignment: Alignment.center,
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
      ),
      SizedBox(
        height: 70.0,
        width: 20.0,
        child: Transform.rotate(
          angle: angle,
          child: Image.asset(
            //pixabay.com
            'assets/images/gameBoard/hand.png',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ),
      ),
    ],
  );
}
