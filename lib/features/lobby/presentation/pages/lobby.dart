import 'dart:async';
import 'dart:math';
import 'package:catchfish/core/notifications/local_notification_service.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/core/widgets/main_menu.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/lobby/presentation/widgets/arrow_bottom.dart';
import 'package:catchfish/features/lobby/presentation/widgets/button_back.dart';
import 'package:catchfish/features/lobby/presentation/widgets/compass.dart';
import 'package:catchfish/features/lobby/presentation/widgets/inventory.dart';
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
  bool _showedWarningYet = false;
  bool isAfterRotating = false;
  late SharedPreferences _prefs;
  bool _usedRotationSinceEneteredScreen = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get flutterLocalNotificationsPlugin => null;

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
    playSound.play(
      path: "assets/sounds/lobby/",
      fileName: "beep.mp3",
    );
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
          return lobbyScreen(state);
        } else if (state is EndRotateCompassState) {
          //BlocProvider.of<LobbyBloc>(context).add(const EnteringLobbyEvent());
          showDailyPrize(state.dailyPrize);
          return lobbyScreen(state);
        } else if (state is ReturningLobbyState) {
          BlocProvider.of<LobbyBloc>(context).add(const EnteringLobbyEvent());
          return lobbyScreen(state);
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
    return SizedBox(
      height: 600,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          if ((state is EnteringLobbyState && !state.hasRotatedTodayYet) ||
              (state is ReturningLobbyState && !state.hasRotatedTodayYet)) ...[
            const SizedBox(
              height: 60.0,
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
          ],
          GestureDetector(
              onTap: () async {
                await flutterLocalNotificationsPlugin.show(
                    12345,
                    "A Notification From My Application",
                    "This notification was sent using Flutter Local Notifcations Package",
                    NotificationService().platformChannelSpecifics,
                    payload: 'data');
              },
              child: arrowBottom()),
          compass(context, _angle),
          nextFreeRotation(),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  showLoginWarning(BuildContext context) async {
    if (_auth.currentUser == null && _showedWarningYet == false) {
      _showedWarningYet = true;
      Timer(const Duration(seconds: 1), () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text('not_logged_in').tr(),
                  content: const Text('text_not_logged_in').tr(),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ));
      });
    }
  }

  //button for activating the rotation of compass
  Widget buttonRotate(BuildContext context, state) {
    return SizedBox(
      width: 300.0,
      child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("click_to_roll",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'skullsandcrossbones',
                  )).tr(),
              const SizedBox(
                width: 10.0,
              ),
              const Icon(Icons.rotate_left),
            ],
          ),
          onPressed: () {
            showLoginWarning(context);
            if (_usedRotationSinceEneteredScreen == false &&
                _auth.currentUser != null) {
              _usedRotationSinceEneteredScreen = true;
              rotateCompass();
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

  Widget lobbyScreen(state) {
    int playerLevel = 1;
    try {
      Timer(const Duration(seconds: 1), () {
        playerLevel = _prefs.getInt("playerLevel") ?? 1;
      });
    } catch (e) {
      print("eeeeeeeeeeeeeeeee=" + e.toString());
    }

    String textLevel = playerLevel.toString();
    String photoURL = FirebaseAuth.instance.currentUser?.photoURL ?? "";
    return WillPopScope(
      onWillPop: () async {
        performBack();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          onDrawerChanged: (isOpened) {},
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(photoURL),
                    radius: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (state.isLoggedIn) {
                        await FirebaseAuth.instance.signOut();
                        performBack();
                      } else {
                        await Navigator.pushNamed(context, '/login');
                        performBack();
                      }
                    },
                    child: Text(
                        FirebaseAuth.instance.currentUser == null
                            ? "Login".tr()
                            : "Logout".tr(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 24.0,
                          fontFamily: 'skullsandcrossbones',
                        )),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text("level:" + textLevel,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 24.0,
                        fontFamily: 'skullsandcrossbones',
                      )).tr(),
                  const SizedBox(
                    width: 20,
                  ),
                  buttonBack(performBack),
                ],
              ),
            ],
          ),
          //in core/widgets/main_menu.dart
          drawer: mainMenu(context),
          body: Stack(children: [
            Container(
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
            ),
            Column(
              children: [
                const SizedBox(
                  height: 50.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //in core/utils/inventory.dart
                    inventory(context, state),
                  ],
                ),
                rotate(state),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
