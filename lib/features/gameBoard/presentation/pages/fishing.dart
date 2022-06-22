import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/caught_fish_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/countdown.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/energy.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/pulse_generator.dart';
import 'package:catchfish/features/introduction/presentation/widgets/boat_steering.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

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

  late AnimationController animationController;
  double _steeringAngle = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<FishingBloc>(context).add(EnteringScreenEvent(
      fishingUsecase: sl.get<FishingUsecase>(),
    ));
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
              ),
            ).tr(),
            content: Text(
              str,
              style: const TextStyle(
                fontFamily: 'skullsandcrossbones',
              ),
            ).tr(),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName("/lobby"));
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
    });
  }

  @override
  Widget build(BuildContext context) {
    var timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      BlocProvider.of<FishingBloc>(context).add(TimerTickEvent(
          fishingUsecase: sl.get<FishingUsecase>(),
          currentCountdownTime: _currentTime));
      if (_seconds == /*5*/ 1) {
        Timer(const Duration(milliseconds: 100), () {
          _seconds = 0;
          BlocProvider.of<FishingBloc>(context)
              .add(GetPulseEvent(fishingUsecase: sl.get<FishingUsecase>()));
        });
      } else {
        _seconds++;
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
                    BlocProvider.of<FishingBloc>(context)
                        .add(AfterTimerTickEvent());

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
                        countdown(context, _currentTime),
                      ],
                    );
                  } else if (state is GameOverState) {
                    popDialogGameOver(state.listAcheivements);
                    return Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        energy(_levelEnergy),
                        countdown(context, _currentTime),
                      ],
                    );
                  } else {
                    return Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        energy(_levelEnergy),
                        countdown(context, _currentTime),
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
