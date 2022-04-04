import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Widget buttonRotate() {
  return SizedBox(
    width: 250.0,
    child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("click_to_roll",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700))
                .tr(),
            const SizedBox(
              width: 10.0,
            ),
            const Icon(Icons.rotate_left),
          ],
        ),
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.greenAccent),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.red))))),
  );
}
