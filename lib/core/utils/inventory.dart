import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:flutter/material.dart';

Widget inventory(state) {
  if (state is EndRotateCompassState || state is EnteringLobbyState) {
    return Row(
      children: [
        const SizedBox(width: 10.0),
        SizedBox(
          width: 32.0,
          height: 32.0,
          child: Image.asset(
            "assets/images/core/utils/coin.png",
          ),
        ),
        const SizedBox(width: 10.0),
        Text(state.inventoryMoney.toString(),
            style: const TextStyle(
              fontSize: 24.0,
              color: Colors.red,
              fontFamily: 'skullsandcrossbones',
            )),
        const SizedBox(width: 30.0),
        SizedBox(
          width: 48.0,
          height: 48.0,
          child: Image.asset(
            "assets/images/core/utils/bait.png",
          ),
        ),
        const SizedBox(width: 10.0),
        Text(state.inventoryBaits.toString(),
            style: const TextStyle(
              fontSize: 24.0,
              color: Colors.red,
              fontFamily: 'skullsandcrossbones',
            )),
        const SizedBox(width: 30.0),
        const SizedBox(
          width: 32.0,
          height: 32.0,
          child: Text(
            "XP",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20.0,
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Text(state.inventoryXP.toString(),
            style: const TextStyle(
              fontSize: 24.0,
              color: Colors.red,
              fontFamily: 'skullsandcrossbones',
            )),
      ],
    );
  } else {
    return Container();
  }
}
