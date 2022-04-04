import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Widget buttonRotate() {
  return TextButton(
      child: const Text("click_to_roll").tr(),
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
      ));
}
