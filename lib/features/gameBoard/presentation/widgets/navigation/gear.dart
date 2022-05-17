import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as UI;

import 'package:flutter_bloc/flutter_bloc.dart';

Widget gear(BuildContext context, String statusGear) {
  return Directionality(
    textDirection: UI.TextDirection.ltr,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
            onTap: () {
              BlocProvider.of<NavigationBloc>(context)
                  .add(GearEvent(selectedNewPosition: 'F2'));
            },
            child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                    color: statusGear == "F2" ? Colors.blue : Colors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Center(
                  child: Text("F2",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                      )),
                ))),
        GestureDetector(
            onTap: () {
              BlocProvider.of<NavigationBloc>(context)
                  .add(GearEvent(selectedNewPosition: 'F1'));
            },
            child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                    color: statusGear == "F1" ? Colors.blue : Colors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Center(
                  child: Text("F1",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                      )),
                ))),
        GestureDetector(
            onTap: () {
              BlocProvider.of<NavigationBloc>(context)
                  .add(GearEvent(selectedNewPosition: 'N'));
            },
            child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                    color: statusGear == "N" ? Colors.blue : Colors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Center(
                  child: Text("N",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                      )),
                ))),
        GestureDetector(
            onTap: () {
              BlocProvider.of<NavigationBloc>(context)
                  .add(GearEvent(selectedNewPosition: 'R'));
            },
            child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                    color: statusGear == "R" ? Colors.blue : Colors.grey,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Center(
                  child: Text("R",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                      )),
                ))),
      ],
    ),
  );
}
