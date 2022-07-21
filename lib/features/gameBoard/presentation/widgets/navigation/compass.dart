import 'package:flutter/material.dart';

Widget compass(BuildContext context, double angle) {
  return Column(
    children: [
      const SizedBox(height: 10.0),
      Transform.rotate(
        angle: -angle,
        child: Image.asset(
          //pixabay.com
          'assets/images/gameBoard/compass.png',
          fit: BoxFit.fill,
          height: 120.0,
          width: 120.0,
          alignment: Alignment.center,
        ),
      ),
    ],
  );
}
