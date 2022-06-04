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
  double angle = 0.0;
  int _seconds = 0;
  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      BlocProvider.of<FishingBloc>(context).add(TimerTickEvent(
          fishingUsecase: sl.get<FishingUsecase>(),
          currentCountdownTime: _currentTime));
      if (_seconds == 5) {
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

                  _currentTime = state.newCountdownTime;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      energy(),
                      countdown(context, _currentTime),
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      energy(),
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
                  return pulseGenerator(context, angle);
                } else if (state is RedButtonPressedState) {
                  print("IsFishCaught=" + state.isFishCaught.toString());
                  return pulseGenerator(context, angle);
                } else {
                  return pulseGenerator(context, angle);
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}
