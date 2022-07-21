import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget energy(int levelEnergy) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("energy:",
          style: TextStyle(
            fontFamily: 'skullsandcrossbones',
            fontSize: 20.0,
            color: Colors.red,
          )).tr(),
      const SizedBox(
        width: 10.0,
      ),
      rectangle(const Color.fromRGBO(44, 87, 89, 1.0), levelEnergy, 0),
      rectangle(const Color.fromRGBO(107, 202, 65, 1.0), levelEnergy, 1),
      rectangle(const Color.fromRGBO(170, 116, 30, 1.0), levelEnergy, 2),
      rectangle(const Color.fromRGBO(244, 104, 93, 1.0), levelEnergy, 3),
      rectangle(const Color.fromRGBO(234, 31, 15, 1.0), levelEnergy, 4),
    ],
  );
}

Widget rectangle(Color color, int currentValue, int myValue) {
  return Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: currentValue == myValue ? Colors.yellow : Colors.transparent,
          width: 3,
        )),
  );
}
