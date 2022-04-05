import 'dart:async';
import 'package:catchfish/core/utils/here_working.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/introduction/presentation/pages/splash.dart';
import 'package:catchfish/features/introduction/presentation/widgets/boat_steering.dart';
import 'package:catchfish/features/introduction/presentation/widgets/flying_bird.dart';
import 'package:catchfish/features/introduction/presentation/widgets/text_loading.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/lobby/presentation/widgets/arrow_bottom.dart';
import 'package:catchfish/features/lobby/presentation/widgets/button_back.dart';
import 'package:catchfish/features/lobby/presentation/widgets/button_rotate.dart';
import 'package:catchfish/features/lobby/presentation/widgets/compass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:catchfish/features/lobby/domain/entities/button_or_arrow.dart';

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> with SingleTickerProviderStateMixin {
  final bool _duringWheelRotation = false;
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
                        height: 100.0,
                      ),
                      state is RotateCompassState
                          ? arrowBottom()
                          : buttonRotate(context),
                      const SizedBox(
                        height: 20.0,
                      ),
                      compass(context, 0),
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
}
