import 'package:catchfish/features/gameBoard/presentation/widgets/button_ignition.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/boat_steering.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/gear.dart';
import 'package:flutter/material.dart';

Widget sailing(BuildContext context, double steeringAngle, bool isBoatRunning,
    String statusGear) {
  return Container(
    height: 1000,
    width: MediaQuery.of(context).size.width,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          //tenor.com
          'assets/images/gameBoard/waves.gif',
        ),
        fit: BoxFit.cover,
      ),
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      boatSteering(context, steeringAngle),
      const SizedBox(
        height: 10.0,
      ),
      buttonIgnition(context, isBoatRunning),
      const SizedBox(
        height: 10.0,
      ),
      isBoatRunning ? gear(context, statusGear) : Container(),
    ]),
  );
}
