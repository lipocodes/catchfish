import 'package:catchfish/features/gameBoard/presentation/widgets/button_ignition.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/boat_steering.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_spin_left.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_spin_right.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/gear.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/compass.dart';
import 'package:flutter/material.dart';

Widget sailing(
  BuildContext context,
  double steeringAngle,
  bool isBoatRunning,
  String statusGear,
) {
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
      const SizedBox(
        height: 50.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buttonSpinRight(context),
          SizedBox(
            height: 30.0,
            child:
                Text((steeringAngle * 57.2957795).floor().toString() + "\u00b0",
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    )),
          ),
          buttonSpinLeft(context),
        ],
      ),
      boatSteering(context, steeringAngle),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
              width: 160.0,
              height: 160.0,
              child: compass(context, steeringAngle)),
          SizedBox(
              width: 100.0,
              height: 100.0,
              child: buttonIgnition(context, isBoatRunning)),
        ],
      ),
      isBoatRunning ? gear(context, statusGear) : Container(),
    ]),
  );
}
