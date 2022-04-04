import 'package:flutter/material.dart';

Widget compass(BuildContext context, double angle) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.50,
    //width: MediaQuery.of(context).size.width * 0.5,
    child: Transform.rotate(
      angle: 4.0,
      child: Image.asset(
        //pixabay.com
        'assets/images/lobby/compass.png',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    ),
  );
}
