import 'dart:async';

import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/selectGroupBloc/selectgroup_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buttonStartGame(BuildContext context) {
  return BlocBuilder<SelectgroupBloc, SelectgroupState>(
    builder: (context, state) {
      if (state is AllowedStartGame) {
        Timer(const Duration(microseconds: 250), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Navigation()),
          );
        });

        return Container();
      } else if (state is NotAllowedStartGame) {
        BlocProvider.of<SelectgroupBloc>(context).add(NeutralEvent());
        return gui(context, true);
      } else {
        return gui(context, false);
      }
    },
  );
}

Widget gui(BuildContext context, bool showWarning) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (showWarning) ...[
        Text(
          "please_select_group".tr(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.red,
            fontStyle: FontStyle.italic,
            fontFamily: 'skullsandcrossbones',
          ),
        ),
      ],
      SizedBox(
        child: TextButton(
          child: const Text("start_game").tr(),
          style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.blue,
              elevation: 20,
              shadowColor: Colors.red,
              //shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              textStyle: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontFamily: 'skullsandcrossbones',
              )),
          onPressed: () {
            BlocProvider.of<SelectgroupBloc>(context)
                .add(PressStartGameButtonEvent());
          },
        ),
      ),
    ],
  );
}