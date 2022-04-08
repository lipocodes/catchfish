import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Widget buttonGoToShop() {
  return TextButton(
      child: Text("go_to_shop".tr(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: Colors.red)))),
      onPressed: () {});
}
