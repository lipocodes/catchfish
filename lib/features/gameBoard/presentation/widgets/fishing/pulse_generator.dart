import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

int timeLastButtonPressed = 0;
late SharedPreferences _prefs;
Widget pulseGenerator(
  BuildContext context,
  double angle,
  String caughtFishDetails,
  String buttonText,
) {
  return gui(context, angle, caughtFishDetails, buttonText);
}

Widget gui(BuildContext context, double angle, String caughtFishDetails,
    String buttonText) {
  List<String> details = caughtFishDetails.split("^^^");

  return Column(
    children: [
      const SizedBox(
        height: 100.0,
      ),
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 216.0,
            width: 296.0,
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
            onTap: () async {
              if (DateTime.now().millisecondsSinceEpoch -
                      timeLastButtonPressed >
                  1000) {
                _prefs = await SharedPreferences.getInstance();
                _prefs.setBool("needPulse", true);

                timeLastButtonPressed = DateTime.now().millisecondsSinceEpoch;
                BlocProvider.of<FishingBloc>(context).add(RedButtonPressedEvent(
                    fishingUsecase: sl.get<FishingUsecase>()));
              }
            },
            child: SizedBox(
              height: 130.0,
              width: 140.0,
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
                    buttonText,
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
