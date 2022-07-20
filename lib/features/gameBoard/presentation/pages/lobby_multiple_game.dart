import 'dart:async';

import 'package:catchfish/features/gameBoard/presentation/blocs/multiplayer/lobby_multiplayer_game_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
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

  Widget gui(List listPlayers) {
    print("xxxxxxxxxxxxxxxxx=" + listPlayers.toString());
    return Container(
      height: 1000,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            //tenor.com
            'assets/images/gameBoard/beach_evening.gif',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Text(
            "Players_waiting_for_game".tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontFamily: 'skullsandcrossbones',
            ),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            height: 500.0,
            child: ListView.builder(
                itemCount: listPlayers.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      //leading: const Icon(Icons.person),

                      title: Center(
                    child: Text(
                      listPlayers[index],
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontSize: 22.0,
                        fontFamily: 'skullsandcrossbones',
                      ),
                    ),
                  ));
                }),
          ),
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body:
              BlocBuilder<LobbyMultiplayerGameBloc, LobbyMultiplayerGameState>(
            builder: (context, state) {
              if (state is JoinMultipleplayerGameState) {
                Timer(const Duration(seconds: 3), () {
                  BlocProvider.of<LobbyMultiplayerGameBloc>(context)
                      .add(GetUpdateMultipleplayerGameEvent());
                });
                return gui([]);
              } else if (state is GetUpdateMultipleplayerGameState) {
                print("bbbbbbbbbbbbbbbbbbb=" +
                    state.multipleplayerEntity.timeTillStartGame.toString() +
                    " " +
                    state.multipleplayerEntity.playersInGroup.toString());
                return gui(state.multipleplayerEntity.playersInGroup);
              } else if (state is QuitMultipleplayerGameState) {
                return gui([]);
              } else {
                return gui([]);
              }
            },
          )),
    );
  }
}
