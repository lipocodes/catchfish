import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buttonRotate(BuildContext context) {
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
        onPressed: () {
          BlocProvider.of<LobbyBloc>(context).add(RotateCompassEvent());
        },
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
