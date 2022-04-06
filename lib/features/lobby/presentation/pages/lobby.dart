import 'dart:async';
import 'dart:math';
import 'package:catchfish/core/utils/here_working.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/lobby/presentation/widgets/arrow_bottom.dart';
import 'package:catchfish/features/lobby/presentation/widgets/button_back.dart';
import 'package:catchfish/features/lobby/presentation/widgets/compass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<LobbyBloc>(context).add(const EnteringLobbyEvent());
  }

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
        }
      });
    });
  }

  showExplantionRoattion() async {
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
                  child: Column(
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
                        child: Text(degreesNet.ceil().toString() + "\u00b0",
                            style: const TextStyle(fontSize: 18.0)),
                      ),
                      compass(context, angle),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
                buttonBack(performBack),
              ]),
            ),
          ),
        );
      },
    );
  }

  //////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////
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
