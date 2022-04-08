import 'package:flutter/material.dart';

Widget flyingBird(double topPosition, double rightPosition) {
  return Positioned(
    top: topPosition,
    right: rightPosition,
    child: SizedBox(
      height: 150,
      child: Image.asset(
        'assets/images/introduction/parrot.gif',
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    ),
  );
}
