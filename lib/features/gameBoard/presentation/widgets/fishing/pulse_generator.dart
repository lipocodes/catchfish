import 'dart:async';

import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/bloc/fishing_bloc.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget pulseGenerator(BuildContext context) {
  double angle = 0.0;
// runs every 5 seconds
  /*Timer.periodic(const Duration(seconds: 5), (timer) {
    BlocProvider.of<FishingBloc>(context)
        .add(GetPulseEvent(fishingUsecase: sl.get<FishingUsecase>()));
  });*/

  return gui(context, angle);
}

Widget gui(BuildContext context, double angle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 150.0,
            width: 200.0,
            child: Image.asset(
              //pixabay.com
              'assets/images/gameBoard/gauge.png',
              fit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          SizedBox(
            height: 70.0,
            width: 20.0,
            child: Transform.rotate(
              angle: angle,
              child: Image.asset(
                //pixabay.com
                'assets/images/gameBoard/hand.png',
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
      GestureDetector(
        onLongPress: () {
          BlocProvider.of<FishingBloc>(context).add(
              RedButtonPressedEvent(fishingUsecase: sl.get<FishingUsecase>()));
        },
        child: SizedBox(
          height: 120.0,
          width: 136.0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                //pixabay.com
                'assets/images/gameBoard/redButton.png',
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              Text(
                "catch".tr(),
                style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
