import 'package:flutter/material.dart';

Widget buttonBack(performBack) {
  return IconButton(
    icon: const Icon(
      Icons.arrow_back,
      size: 32,
      color: Colors.white,
    ),
    onPressed: () {
      performBack();
    },
  );
}
