import 'package:flutter/material.dart';

Widget inventory(BuildContext context, int inventoryMoney, int inventoryBaits,
    int inventoryXP) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(width: 5.0),
      SizedBox(
        width: 32.0,
        height: 32.0,
        child: Image.asset(
          "assets/images/core/utils/coin.png",
        ),
      ),
      const SizedBox(width: 5.0),
      Text(inventoryMoney.toString(),
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.red,
            fontFamily: 'skullsandcrossbones',
          )),
      const SizedBox(width: 40.0),
      SizedBox(
        width: 48.0,
        height: 48.0,
        child: Image.asset(
          "assets/images/core/utils/bait.png",
        ),
      ),
      const SizedBox(width: 5.0),
      Text(inventoryBaits.toString(),
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.red,
            fontFamily: 'skullsandcrossbones',
          )),
      const SizedBox(width: 40.0),
      const SizedBox(
        width: 32.0,
        height: 32.0,
        child: Padding(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(
            "XP",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      //const SizedBox(width: 5.0),
      Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(inventoryXP.toString(),
            style: const TextStyle(
              fontSize: 24.0,
              color: Colors.red,
              fontFamily: 'skullsandcrossbones',
            )),
      ),
      //const SizedBox(width: 20.0),
    ],
  );
}
