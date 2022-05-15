import 'package:flutter/material.dart';

Widget sailing(BuildContext context) {
  return Container(
    height: 1000,
    width: MediaQuery.of(context).size.width,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          //tenor.com
          'assets/images/lobby/dolphins.gif',
        ),
        fit: BoxFit.cover,
      ),
    ),
  );
}
