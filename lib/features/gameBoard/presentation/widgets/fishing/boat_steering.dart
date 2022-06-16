import 'package:flutter/material.dart';

Widget boatSteering(BuildContext context, double steeringAngle) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.25,
    //width: MediaQuery.of(context).size.width * 0.9,
    child: Transform.rotate(
      angle: steeringAngle,
      child: Image.asset(
        'assets/images/gameBoard/boat_steering.png',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    ),
  );
}
