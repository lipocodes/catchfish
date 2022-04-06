import 'dart:async';
import 'dart:math';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/lobby/presentation/widgets/arrow_bottom.dart';
import 'package:catchfish/features/lobby/presentation/widgets/button_back.dart';
import 'package:catchfish/features/lobby/presentation/widgets/compass.dart';
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
  double angle = 0.0;
  double millisecondsElasped = 0.0;
  late PlaySound playSound;
  double degreesNet = 0.0;
  int _dayLastRotation = 0;
  String _dailyPrize = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retreivePrefs();
    BlocProvider.of<LobbyBloc>(context).add(const EnteringLobbyEvent());
  }

  //Retreive existing prefs
  retreivePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dayLastRotation = prefs.getInt("dayLastRotation") ?? 0;
    _dailyPrize = prefs.getString("dailyPrize") ?? "";
  }

  //custom BACK operation
  performBack() {
    BlocProvider.of<LobbyBloc>(context).add(LeavingLobbyEvent());
    Navigator.pop(context, true);
    Navigator.pop(context, true);
    Navigator.pushNamed(context, '/');
  }

  //rotate the compass using a Timer
  void rotateCompass() async {
    BlocProvider.of<LobbyBloc>(context).add(RotateCompassEvent());
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
          angle += speedInRadians;
          speedInRadians -= 0.5;
        } else {
          double degreesBrute = angle * 57.2957795;
          degreesNet = degreesBrute % 360;
          t.cancel();
          playSound.stop();
          showDailyPrize("10 XP");
        }
      });
    });
  }

  //if user clicks on 'Wjy rotate this compass?'
  showExplantionRoattion() async {
    playSound = PlaySound();
    playSound.play(path: "assets/sounds/lobby/", fileName: "beep.mp3");
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.greenAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("what_is_this").tr(),
          content: const Text("compass_explantion").tr(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK',
                  style: TextStyle(
                    fontSize: 18.0,
                  )),
            ),
          ],
        );
      },
    );
  }

  //after compass stops rotating, we show the prize to user
  showDailyPrize(String dailyPrize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('dailyPrize', dailyPrize);
    _dailyPrize = dailyPrize;
    prefs.setInt("dayLastRotation", DateTime.now().day);
    _dayLastRotation = DateTime.now().day;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.greenAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("your_daily_prize").tr(),
          content: Text(dailyPrize),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK',
                  style: TextStyle(
                    fontSize: 18.0,
                  )),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LobbyBloc, LobbyState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            performBack();
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        //tenor.com
                        'assets/images/lobby/waves.gif',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: DateTime.now().day == _dayLastRotation
                      ? prize()
                      : Column(
                          children: [
                            const SizedBox(
                              height: 70.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                showExplantionRoattion();
                              },
                              child: const Text(
                                "explanation_compass",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                ),
                              ).tr(),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            state is RotateCompassState
                                ? arrowBottom()
                                : buttonRotate(context),
                            SizedBox(
                              height: 30.0,
                              child: Text(
                                  degreesNet.ceil().toString() + "\u00b0",
                                  style: const TextStyle(fontSize: 18.0)),
                            ),
                            compass(context, angle),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonBack(performBack),
                    buttonGoToShop(),
                  ],
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  //////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////
  Widget buttonGoToShop() {
    return TextButton(
        child: Text("Go to Shop".toUpperCase(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        style: ButtonStyle(
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.red)))),
        onPressed: () {});
  }

  Widget prize() {
    return SizedBox(
      width: 200.0,
      height: 600.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "your_daily_prize",
            style: TextStyle(
                color: Colors.red, fontSize: 42.0, fontWeight: FontWeight.w800),
          ).tr(),
          const SizedBox(height: 10.0),
          Text(
            _dailyPrize,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.w400),
          ).tr(),
          const SizedBox(height: 20.0),
          buttonEnableCompass(context),
        ],
      ),
    );
  }

  Widget buttonEnableCompass(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("click_to_enable_compass",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w700))
                  .tr(),
              const SizedBox(
                width: 10.0,
              ),
              const Icon(Icons.compass_calibration_sharp),
            ],
          ),
          onPressed: () {
            setState(() {
              _dayLastRotation = 0;
              BlocProvider.of<LobbyBloc>(context)
                  .add(const EnteringLobbyEvent());
            });
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

  Widget buttonRotate(BuildContext context) {
    return SizedBox(
      width: 250.0,
      child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("click_to_roll",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w700))
                  .tr(),
              const SizedBox(
                width: 10.0,
              ),
              const Icon(Icons.rotate_left),
            ],
          ),
          onPressed: () {
            BlocProvider.of<LobbyBloc>(context).add(RotateCompassEvent());
            rotateCompass();
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
}