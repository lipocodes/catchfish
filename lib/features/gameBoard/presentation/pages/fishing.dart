import 'package:catchfish/features/gameBoard/domain/entities/fishing/caught_fish_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/bloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/countdown.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/energy.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/pulse_generator.dart';
import 'package:catchfish/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class Fishing extends StatefulWidget {
  const Fishing({Key? key}) : super(key: key);

  @override
  State<Fishing> createState() => _FishingState();
}

class _FishingState extends State<Fishing> {
  String _currentTime = "05:00";
  int _levelEnergy = 0;
  double angle = 0.0;
  int _seconds = 0;
  String _caughtFishDetails = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FishingBloc>(context).add(EnteringScreenEvent(
      fishingUsecase: sl.get<FishingUsecase>(),
    ));
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
            body: Column(
          children: [
            BlocBuilder<FishingBloc, FishingState>(
              builder: (context, state) {
                if (state is TimerTickState) {
                  BlocProvider.of<FishingBloc>(context)
                      .add(AfterTimerTickEvent());

                  _currentTime = state.newCountdownTime
                      .substring(0, state.newCountdownTime.indexOf("^^^"));
                  if (_currentTime == "00:00") {
                    timer.cancel();
                  }
                  _levelEnergy = int.parse(state.newCountdownTime
                      .substring(state.newCountdownTime.indexOf("^^^") + 3));
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      energy(_levelEnergy),
                      countdown(context, _currentTime),
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
        )),
      ),
    );
  }
}
