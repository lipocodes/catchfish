import 'dart:async';

import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/bloc/fishing_bloc.dart';
import 'package:catchfish/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget countdown(BuildContext context) {
  String currentTime = "05:00";
  // runs every 1 second
  /*Timer.periodic(const Duration(seconds: 1), (timer) {
    BlocProvider.of<FishingBloc>(context).add(TimerTickEvent(
        fishingUsecase: sl.get<FishingUsecase>(),
        currentCountdownTime: currentTime));
  });*/

  return gui(currentTime);
}

Widget gui(String currentTime) {
  return Text(currentTime,
      style: const TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
        fontFamily: 'skullsandcrossbones',
      ));
}
