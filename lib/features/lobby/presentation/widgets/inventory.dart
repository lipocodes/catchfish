import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:flutter/material.dart';

Widget inventory(BuildContext context, state) {
  //if user is not logged in, warn him

  if (state is EndRotateCompassState ||
      state is EnteringLobbyState ||
      state is ReturningLobbyState) {
    return Row(
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
        Text(state.inventoryMoney.toString(),
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
        Text(state.inventoryBaits.toString(),
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
          child: Text(state.inventoryXP.toString(),
              style: const TextStyle(
                fontSize: 24.0,
                color: Colors.red,
                fontFamily: 'skullsandcrossbones',
              )),
        ),
      ],
    );
  } else {
    return Container();
  }
}
