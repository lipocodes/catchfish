import 'package:flutter/material.dart';

Widget flyingBird(double topPosition, double rightPosition) {
  return Positioned(
    top: topPosition,
    right: rightPosition,
    child: SizedBox(
      height: 100,
      child: Image.asset(
        'assets/images/introduction/flying_bird.gif',
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    ),
  );
}
