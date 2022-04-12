import 'dart:async';
import 'dart:math';
import 'package:catchfish/core/utils/inventory.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/introduction/presentation/pages/splash.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/lobby/presentation/widgets/arrow_bottom.dart';
import 'package:catchfish/features/lobby/presentation/widgets/button_back.dart';
import 'package:catchfish/features/lobby/presentation/widgets/compass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> with SingleTickerProviderStateMixin {
  double _angle = 0.0;
  double millisecondsElasped = 0.0;
  late PlaySound playSound;
  double degreesNet = 0.0;

  bool isAfterRotating = false;
  late SharedPreferences _prefs;
  bool _usedRotationSinceEneteredScreen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retreivePrefs();
    BlocProvider.of<LobbyBloc>(context).add(const EnteringLobbyEvent());
  }

  //Retreive existing prefs
  retreivePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //custom BACK operation
  performBack() async {
    BlocProvider.of<LobbyBloc>(context).add(LeavingLobbyEvent());
    Navigator.pop(context, true);
    Navigator.pop(context, true);
    Navigator.pushNamed(context, '/');
  }

  //rotate the compass using a Timer
  void rotateCompass() async {
    _angle = 0.0;
    playSound = PlaySound();
    playSound.play(path: "assets/sounds/lobby/", fileName: "bounce.mp3");
    var random = Random();
    //randomize: the speed the compass rotates
    int num = random.nextInt(360);
    num += 1440;

    // we need a large enough number
    double speedInRadians = num * 0.01745329;
    Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      setState(() {
        if (speedInRadians > 0) {
          _angle += speedInRadians;
          speedInRadians -= 0.5;
        } else {
          double degreesBrute = _angle * 57.2957795;
          degreesNet = degreesBrute % 360;
          t.cancel();
          playSound.stop();
          isAfterRotating = true;

          BlocProvider.of<LobbyBloc>(context)
              .add(EndRotateCompassEvent(generatedNumber: degreesNet));
        }
      });
    });
  }

  //if user clicks on 'Why rotate this compass?'
  showExplantionRotation() async {
    playSound = PlaySound();
    playSound.play(path: "assets/sounds/lobby/", fileName: "beep.mp3");
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
            "what_is_this",
            style: TextStyle(
              fontFamily: 'skullsandcrossbones',
            ),
          ).tr(),
          content: const Text(
            "compass_explantion",
            style: TextStyle(
              fontFamily: 'skullsandcrossbones',
            ),
          ).tr(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue,
                    fontFamily: 'skullsandcrossbones',
                  )),
            ),
          ],
        );
      },
    );
  }

  //after compass finishes rotating, we show the prize to user
  showDailyPrize(String dailyPrize) async {
    if (_usedRotationSinceEneteredScreen == false) {
      return;
    }
    Future.delayed(const Duration(seconds: 1), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/lobby/scroll.jpg",
              ),
              Text(
                dailyPrize.tr(),
                style: const TextStyle(
                  fontSize: 32,
                  fontFamily: 'skullsandcrossbones',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LobbyBloc, LobbyState>(
      builder: (context, state) {
        if (state is EnteringLobbyState) {
          return WillPopScope(
            onWillPop: () async {
              performBack();
              return true;
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Stack(children: [
                  rotate(state),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buttonBack(performBack),
                      //in core/utils/inventory.dart
                      inventory(context, state),
                    ],
                  ),
                ]),
              ),
            ),
          );
        } else if (state is EndRotateCompassState) {
          showDailyPrize(state.dailyPrize);
          return WillPopScope(
            onWillPop: () async {
              performBack();
              return true;
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Stack(children: [
                  rotate(state),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buttonBack(performBack),
                      //in core/utils/inventory.dart
                      inventory(context, state),
                    ],
                  ),
                ]),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  //////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////
  //The wheel we see on the screen
  Widget rotate(state) {
    return Container(
      height: 1000,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            //tenor.com
            'assets/images/lobby/dolphins.gif',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 90.0,
          ),
          GestureDetector(
            onTap: () {
              showExplantionRotation();
            },
            child: const Text(
              "explanation_compass",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.red,
                decoration: TextDecoration.underline,
                fontFamily: 'skullsandcrossbones',
              ),
            ).tr(),
          ),
          buttonRotate(context, state),
          arrowBottom(),
          compass(context, _angle),
          /* SizedBox(
            height: 30.0,
            child: Text(degreesNet.ceil().toString() + "\u00b0",
                style: const TextStyle(
                  fontSize: 28.0,
                  color: Colors.white,
                  fontFamily: 'skullsandcrossbones',
                )),
          ),*/
          if (state is EndRotateCompassState ||
              (state is EnteringLobbyState &&
                  state.hasRotatedTodayYet == true)) ...[
            nextFreeRotation(),
          ],
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  //button for activating the rotation of compass
  Widget buttonRotate(BuildContext context, state) {
    return SizedBox(
      width: 250.0,
      child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is EndRotateCompassState ||
                  (state is EnteringLobbyState &&
                      state.hasRotatedTodayYet == true)) ...[
                const Text("click_to_enable_compass",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'skullsandcrossbones',
                    )).tr(),
              ] else ...[
                const Text("click_to_roll",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'skullsandcrossbones',
                    )).tr(),
              ],
              const SizedBox(
                width: 10.0,
              ),
              const Icon(Icons.rotate_left),
            ],
          ),
          onPressed: () {
            if (_usedRotationSinceEneteredScreen == false) {
              _usedRotationSinceEneteredScreen = true;
              rotateCompass();
            } else {
              Navigator.pop(context, true);
              Navigator.pop(context, true);
              Navigator.pushNamed(context, '/');
            }
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

  //Text telling user when next free rotation will be available
  Widget nextFreeRotation() {
    return Text("next_free_rotation".tr(),
        style: const TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: 'skullsandcrossbones',
        ));
  }
}
