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
late SharedPreferences prefs;
Widget pulseGenerator(
    BuildContext context, double angle, String caughtFishDetails) {
  retreivePrefs();
  return gui(context, angle, caughtFishDetails);
}

retreivePrefs() async {
  prefs = await SharedPreferences.getInstance();
  redButtonGearStatus = prefs.getInt("redButtonGearStatus") ?? 0;
}

Widget gui(BuildContext context, double angle, String caughtFishDetails) {
  List<String> details = caughtFishDetails.split("^^^");

  return Column(
    children: [
      const SizedBox(
        height: 150.0,
      ),
      if (redButtonGearStatus == 0) ...[
        Stack(
          children: [
            Center(
              child: SizedBox(
                height: 100.0,
                width: 100.0,
                child: Image.asset(
                  //pixabay.com
                  'assets/images/gameBoard/mini_gauge.png',
                  fit: BoxFit.fill,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Positioned(
              left: 170,
              top: 50,
              child: SizedBox(
                height: 40.0,
                width: 20.0,
                child: Transform.rotate(
                  angle: 0,
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
            ),
          ],
        ),
      ],
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 250.0,
            width: 320.0,
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
            height: 84.0,
            width: 24.0,
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
          GestureDetector(
            onLongPressStart: (details) {
              if (DateTime.now().millisecondsSinceEpoch -
                      timeLastButtonPressed >
                  1000) {
                if (redButtonGearStatus == 2) {
                  final snackdemo = SnackBar(
                    content: Text(
                      "leave_button_catch_fish".tr(),
                      style: const TextStyle(
                        fontFamily: 'skullsandcrossbones',
                        fontSize: 18.0,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    elevation: 10,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(5),
                  );
                  Future.delayed(const Duration(milliseconds: 100), () {
                    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                  });
                }
              }
            },
            onLongPressEnd: (details) {
              if (redButtonGearStatus == 2) {
                prefs.setInt("redButtonGearStatus", 0);
              }
            },
            onTap: () async {
              if (DateTime.now().millisecondsSinceEpoch -
                      timeLastButtonPressed >
                  1000) {
                if (redButtonGearStatus == 0) {
                  prefs.setInt("redButtonGearStatus", 1);
                }

                timeLastButtonPressed = DateTime.now().millisecondsSinceEpoch;
                BlocProvider.of<FishingBloc>(context).add(RedButtonPressedEvent(
                    fishingUsecase: sl.get<FishingUsecase>()));
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
                  ] else if (redButtonGearStatus == 2) ...[
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
