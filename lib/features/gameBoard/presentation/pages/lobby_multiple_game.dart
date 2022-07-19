import 'dart:async';

import 'package:catchfish/features/gameBoard/presentation/blocs/multiplayer/lobby_multiplayer_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyMultipleGame extends StatefulWidget {
  const LobbyMultipleGame({Key? key}) : super(key: key);

  @override
  State<LobbyMultipleGame> createState() => _LobbyMultipleGameState();
}

class _LobbyMultipleGameState extends State<LobbyMultipleGame> {
  @override
  void initState() {
    super.initState();
    //add event: join existibg group for a game OR craete a new one
    BlocProvider.of<LobbyMultiplayerGameBloc>(context)
        .add(JoinMultipleplayerGameEvent());
  }

  performBack() {
    BlocProvider.of<LobbyMultiplayerGameBloc>(context)
        .add(QuitMultipleplayerGameEvent());
    Navigator.pop(context);
  }

  Widget gui() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return performBack();
      },
      child: Scaffold(
          backgroundColor: Colors.transparent,
          //extendBodyBehindAppBar: true,
          //appBar: appBar(context),
          body:
              BlocBuilder<LobbyMultiplayerGameBloc, LobbyMultiplayerGameState>(
            builder: (context, state) {
              if (state is JoinMultipleplayerGameState) {
                Timer(const Duration(seconds: 3), () {
                  BlocProvider.of<LobbyMultiplayerGameBloc>(context)
                      .add(GetUpdateMultipleplayerGameEvent());
                });
                return gui();
              } else if (state is GetUpdateMultipleplayerGameState) {
                print("bbbbbbbbbbbbbbbbbbb=" +
                    state.multipleplayerEntity.timeTillStartGame.toString() +
                    " " +
                    state.multipleplayerEntity.playersInGroup.toString());
                return gui();
              } else if (state is QuitMultipleplayerGameState) {
                return gui();
              } else {
                return gui();
              }
            },
          )),
    );
  }
}
