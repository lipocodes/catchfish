import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/boat_steering.dart';
import 'package:flutter/material.dart';

Widget sailing(BuildContext context) {
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
      boatSteering(context, 0),
    ]),
  );
}
