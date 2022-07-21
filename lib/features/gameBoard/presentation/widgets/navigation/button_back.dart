import 'package:catchfish/features/gameBoard/domain/usecases/navigation/navigation_usecases.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buttonBack(BuildContext context) {
  return IconButton(
    icon: const Icon(
      Icons.arrow_back,
      size: 28,
      color: Colors.blue,
    ),
    onPressed: () async {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              "leave_game",
              style: TextStyle(
                fontFamily: 'skullsandcrossbones',
              ),
            ).tr(),
            content: const Text(
              "text_leave_game",
              style: TextStyle(
                fontFamily: 'skullsandcrossbones',
              ),
            ).tr(),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  BlocProvider.of<NavigationBloc>(context).add(
                      LeavingNavigationEvent(
                          navigationUsecases: sl.get<NavigationUsecases>()));
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue,
                      fontFamily: 'skullsandcrossbones',
                    )).tr(),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('cancel',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.blue,
                      fontFamily: 'skullsandcrossbones',
                    )).tr(),
              ),
            ],
          );
        },
      );
    },
  );
}
