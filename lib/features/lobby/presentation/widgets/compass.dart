import 'package:flutter/material.dart';

Widget compass(BuildContext context, double angle) {
  return SizedBox(
    height: 300.0,
    width: 300.0,
    child: Transform.rotate(
      angle: -angle,
      child: Image.asset(
        //pixabay.com
        'assets/images/lobby/compass.png',
        fit: BoxFit.fill,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    ),
  );
}
