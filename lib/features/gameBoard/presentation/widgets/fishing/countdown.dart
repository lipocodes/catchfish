import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget countdown(BuildContext context, String newCountdownTime, int numPlayers,
    int inventoryBaits) {
  return gui(newCountdownTime, numPlayers, inventoryBaits);
}

Widget gui(String currentTime, int numPlayers, int inventoryBaits) {
  String players = "players".tr() + ": " + numPlayers.toString();
  String baits = "baits".tr() + ": " + inventoryBaits.toString();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(players,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontFamily: 'skullsandcrossbones',
          )).tr(),
      Text(baits,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontFamily: 'skullsandcrossbones',
          )).tr(),
      Text(currentTime,
          style: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontFamily: 'skullsandcrossbones',
          )),
    ],
  );
}
