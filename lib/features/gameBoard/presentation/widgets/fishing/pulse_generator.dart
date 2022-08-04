import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

int timeLastButtonPressed = 0;
// 0: show "Cast" button
//1: Let compass run and get pulses
//2: Show "Catch" button
//3: "Catch" button is long pressed, show inner game
int redButtonGearStatus = 0;
bool isItAfterCatchState = false;
late SharedPreferences prefs;
bool hasPlayerPressedRedButton = false;
Widget pulseGenerator(BuildContext context, double angle,
    String caughtFishDetails, double angleMiniGauge) {
  retreivePrefs();
  return gui(context, angle, caughtFishDetails, angleMiniGauge);
}

retreivePrefs() async {
  prefs = await SharedPreferences.getInstance();
  redButtonGearStatus = prefs.getInt("redButtonGearStatus") ?? 0;
}

Widget gui(BuildContext context, double angle, String caughtFishDetails,
    double angleMiniGauge) {
  List<String> details = caughtFishDetails.split("^^^");

  return Column(
    children: [
      if (caughtFishDetails.isNotEmpty) ...[
        const SizedBox(
            height: 400.0,
            width: 400,
            child: Image(
                image: AssetImage('assets/images/gameBoard/success.gif'))),
      ] else if (redButtonGearStatus == 2) ...[
        const SizedBox(
            height: 400.0,
            width: 400.0,
            child:
                Image(image: AssetImage('assets/images/gameBoard/jumping.gif')))
      ] else ...[
        const SizedBox(
          height: 400.0,
          width: 400.0,
        )
      ],
      Stack(
        children: [
          GestureDetector(
            onTap: () async {
              //if player has no more baits, he can't try catching a fish..
              int inventoryBaits = prefs.getInt("inventoryBaits") ?? 0;
              if (inventoryBaits < 1) {
                return;
              }
              if (DateTime.now().millisecondsSinceEpoch -
                      timeLastButtonPressed >
                  1000) {
                if (redButtonGearStatus == 0) {
                  prefs.setInt("redButtonGearStatus", 1);
                  timeLastButtonPressed = DateTime.now().millisecondsSinceEpoch;
                } else if (redButtonGearStatus == 2) {
                  prefs.setInt("inventoryBaits", inventoryBaits - 1);

                  timeLastButtonPressed = DateTime.now().millisecondsSinceEpoch;
                  BlocProvider.of<FishingBloc>(context).add(
                      RedButtonPressedEvent(
                          fishingUsecase: sl.get<FishingUsecase>(),
                          angleMiniGauge: angleMiniGauge));
                  //prefs.setInt("redButtonGearStatus", 1);
                }
              }
            },
            child: SizedBox(
              height: 150.0,
              width: 220.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (redButtonGearStatus == 0) ...[
                    Image.asset(
                      //pixabay.com
                      'assets/images/gameBoard/redButton.png',
                      fit: BoxFit.fill,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
                    Text(
                      "cast".tr(),
                      style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ] else if (redButtonGearStatus == 1 ||
                      redButtonGearStatus == 2) ...[
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
                ],
              ),
            ),
          ),
        ],
      ),
      if (caughtFishDetails.isNotEmpty) ...[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("catch:".tr() + details[0].tr(),
                style: const TextStyle(
                  fontFamily: 'skullsandcrossbones',
                  fontSize: 24.0,
                  color: Colors.white,
                  backgroundColor: Colors.blueAccent,
                )),
          ],
        ),
      ],
    ],
  );
}
