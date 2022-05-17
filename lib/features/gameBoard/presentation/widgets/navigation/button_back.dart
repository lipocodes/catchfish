import 'package:flutter/material.dart';

Widget buttonBack(BuildContext context) {
  return IconButton(
    icon: const Icon(
      Icons.arrow_back,
      size: 28,
      color: Colors.blue,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}
