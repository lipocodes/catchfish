import 'package:flutter/material.dart';

Widget compass(BuildContext context, double angle) {
  return Transform.rotate(
    angle: -angle,
    child: Image.asset(
      //pixabay.com
      'assets/images/gameBoard/compass.png',
      fit: BoxFit.fill,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    ),
  );
}
