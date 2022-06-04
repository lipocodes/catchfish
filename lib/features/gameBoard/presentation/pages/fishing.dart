import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/bloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/countdown.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/energy.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/pulse_generator.dart';
import 'package:catchfish/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Fishing extends StatefulWidget {
  const Fishing({Key? key}) : super(key: key);

  @override
  State<Fishing> createState() => _FishingState();
}

class _FishingState extends State<Fishing> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        home: Scaffold(
            body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                energy(),
                countdown(context),
              ],
            ),
            BlocBuilder<FishingBloc, FishingState>(
              builder: (context, state) {
                if (state is GetPulseState) {
                  BlocProvider.of<FishingBloc>(context)
                      .add(BetweenPulsesEvent());
                  return pulseGenerator(context);
                } else {
                  return pulseGenerator(context);
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}
