import 'package:catchfish/features/gameBoard/domain/entities/fishing/caught_fish_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';

import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/countdown.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/energy.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/pulse_generator.dart';
import 'package:catchfish/features/lobby/presentation/pages/lobby.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Fishing extends StatefulWidget {
  const Fishing({Key? key}) : super(key: key);

  @override
  State<Fishing> createState() => _FishingState();
}

class _FishingState extends State<Fishing> {
  String _currentTime = "01:00";
  int _levelEnergy = 0;
  double angle = 0.0;
  int _seconds = 0;
  String _caughtFishDetails = "";
  double rightPositionBird = 60.0;
  double topPositionBird = 100.0;
  int _numPlayers = 0;
  var _prefs;
  bool _amIGroupLeader = false;
  bool _gameStarted = false;
  late AnimationController animationController;
  double _steeringAngle = 0.0;
  int _selectedGroupType = 0;
  String _groupLeader = "";
  bool _isDialogOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retreivePrefs();
    BlocProvider.of<FishingBloc>(context).add(EnteringScreenEvent(
      fishingUsecase: sl.get<FishingUsecase>(),
    ));
  }

  retreivePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _selectedGroupType = await _prefs.getInt("selectedGroupType") ?? 0;
    _amIGroupLeader = await _prefs.getBool('amIGroupLeader') ?? false;
    _gameStarted = await _prefs.getBool('gameStarted') ?? false;
  }

  popDialogGameOver(List<String> listAcheivments) async {
    String str = "";
    for (int a = 0; a < listAcheivments.length; a++) {
      String temp = listAcheivments[a];
      List t = temp.split("^^^");
      str += (a + 1).toString() + ". " + t[0] + " - " + t[1] + "\n\n";
    }
    str += "refer_to_private_collection".tr();
    Future.delayed(const Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "game_over".tr(),
              style: const TextStyle(
                fontFamily: 'skullsandcrossbones',
                fontSize: 24.0,
              ),
            ).tr(),
            content: Text(
              str,
              style: const TextStyle(
                fontFamily: 'skullsandcrossbones',
                fontSize: 24.0,
              ),
            ).tr(),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Lobby()),
                      ModalRoute.withName("/lobby"));
                },
                child: const Text('next',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue,
                      fontFamily: 'skullsandcrossbones',
                    )).tr(),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      BlocProvider.of<FishingBloc>(context).add(TimerTickEvent(
          fishingUsecase: sl.get<FishingUsecase>(),
          currentCountdownTime: _currentTime));
      if (_gameStarted) {
        _isDialogOpen = false;
        if (_seconds == /*5*/ 1) {
          Timer(const Duration(milliseconds: 100), () {
            _seconds = 0;
            BlocProvider.of<FishingBloc>(context)
                .add(GetPulseEvent(fishingUsecase: sl.get<FishingUsecase>()));
          });
        } else {
          _seconds++;
        }
      } else if (_amIGroupLeader) {
        if (!_isDialogOpen) {
          _isDialogOpen = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: const Text(
                  "click_start_game",
                  style: TextStyle(
                    fontFamily: 'skullsandcrossbones',
                    fontSize: 24.0,
                  ),
                ).tr(),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      BlocProvider.of<FishingBloc>(context)
                          .add(StartGameEvent());
                    },
                    child: const Text('next',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blue,
                          fontFamily: 'skullsandcrossbones',
                        )).tr(),
                  ),
                ],
              );
            },
          );
        }
      } else if (!_amIGroupLeader) {
        if (!_isDialogOpen) {
          _isDialogOpen = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: const Text(
                  "wait_game_start",
                  style: TextStyle(
                    fontFamily: 'skullsandcrossbones',
                  ),
                ).tr(),
              );
            },
          );
        } else {
          _isDialogOpen = false;
          Navigator.pop(context);
        }
      }
    });
    return SafeArea(
      child: MaterialApp(
        home: Scaffold(
            body: Container(
          height: 1000,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                //tenor.com
                'assets/images/gameBoard/yachts.jpeg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              //boatSteering(context, _steeringAngle),
              BlocBuilder<FishingBloc, FishingState>(
                builder: (context, state) {
                  if (state is TimerTickState) {
                    if (state.namePlayerCaughtFish.isNotEmpty) {
                      final snackdemo = SnackBar(
                        content: Text(
                          state.namePlayerCaughtFish + "caught_fish".tr(),
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

                    BlocProvider.of<FishingBloc>(context)
                        .add(AfterTimerTickEvent());
                    _gameStarted = state.gameStarted;
                    _groupLeader = state.groupLeader;
                    _numPlayers = state.numPlayers;
                    _currentTime = state.newCountdownTime
                        .substring(0, state.newCountdownTime.indexOf("^^^"));
                    if (_currentTime == "00:00") {
                      timer.cancel();
                      BlocProvider.of<FishingBloc>(context)
                          .add(GameOverEvent());
                    }
                    _levelEnergy = int.parse(state.newCountdownTime
                        .substring(state.newCountdownTime.indexOf("^^^") + 3));
                    return Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        energy(_levelEnergy),
                        countdown(context, _currentTime, _numPlayers),
                      ],
                    );
                  } else if (state is GameOverState) {
                    BlocProvider.of<FishingBloc>(context)
                        .add(BetweenPulsesEvent());
                    popDialogGameOver(state.listAcheivements);
                    return Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        energy(_levelEnergy),
                        countdown(context, _currentTime, _numPlayers),
                      ],
                    );
                  } else {
                    return Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        energy(_levelEnergy),
                        countdown(context, _currentTime, _numPlayers),
                      ],
                    );
                  }
                },
              ),
              BlocBuilder<FishingBloc, FishingState>(
                builder: (context, state) {
                  if (state is GetPulseState) {
                    angle = state.angle;
                    BlocProvider.of<FishingBloc>(context)
                        .add(BetweenPulsesEvent());
                    return pulseGenerator(context, angle, _caughtFishDetails);
                  } else if (state is RedButtonPressedState) {
                    if (state.caughtFishDetails.isNotEmpty) {
                      _caughtFishDetails = state.caughtFishDetails;
                    }
                    sl.get<CaughtFishEntity>().isFishCaught = false;
                    sl.get<CaughtFishEntity>().caughtFishDetails = "";
                    return pulseGenerator(context, angle, _caughtFishDetails);
                  } else {
                    return pulseGenerator(context, angle, _caughtFishDetails);
                  }
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
