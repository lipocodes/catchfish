import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/button_ignition.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/boat_steering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget sailing(BuildContext context, double steeringAngle, bool isBoatRunning) {
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
    child: Column(children: [
      const SizedBox(
        height: 50.0,
      ),
      boatSteering(context, steeringAngle),
      buttonIgnition(context, isBoatRunning),
    ]),
  );
}
