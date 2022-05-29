import 'package:audioplayers/audioplayers.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buttonIgnition(BuildContext context, bool isBoatRunning) {
  return GestureDetector(
    onTap: () {
      BlocProvider.of<NavigationBloc>(context).add(IgnitionEvent());
    },
    child: ClipOval(
      child: Container(
        color: isBoatRunning ? Colors.red : Colors.grey,
        height: 80.0,
        width: 80.0,
        child: const Center(
            child: Icon(
          Icons.directions_boat,
          size: 32.0,
        )),
      ),
    ),
  );
  ;
}
