import 'package:flutter/material.dart';

Widget flyingBird(
    double topPosition, double rightPosition, bool pngOrGif, bool isEvenTick) {
  return Positioned(
    top: topPosition,
    right: rightPosition,
    child: SizedBox(
      height: 160,
      width: 160,
      child: Image.asset(
        pngOrGif
            ? isEvenTick
                ? 'assets/images/introduction/parrot_wings_up.png'
                : 'assets/images/introduction/parrot_wings_down.png'
            : 'assets/images/introduction/parrot_standing.png',
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    ),
  );
}
