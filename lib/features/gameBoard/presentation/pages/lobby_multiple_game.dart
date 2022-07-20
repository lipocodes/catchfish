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
  List _listPlayers = [];
  int _timeTillGameStarts = 100;
  @override
  void initState() {
    super.initState();
    //add event: join existibg group for a game OR craete a new one
    BlocProvider.of<LobbyMultiplayerGameBloc>(context)
        .add(JoinMultipleplayerGameEvent());
    Timer.periodic(const Duration(seconds: 3), (timer) {
      BlocProvider.of<LobbyMultiplayerGameBloc>(context)
          .add(GetUpdateMultipleplayerGameEvent());
    });
  }

  performBack() {
    BlocProvider.of<LobbyMultiplayerGameBloc>(context)
        .add(QuitMultipleplayerGameEvent());
    Navigator.pop(context);
  }

  Widget gui(List listPlayers) {
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
                      listPlayers[index].toString(),
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
              print("ggggggggggggggggggg=" + state.toString());
              if (state is JoinMultipleplayerGameState) {
                return gui([]);
              } else if (state is GetUpdateMultipleplayerGameState) {
                _listPlayers = state.multipleplayerEntity.playersInGroup;
                _timeTillGameStarts =
                    state.multipleplayerEntity.timeTillStartGame;
                BlocProvider.of<LobbyMultiplayerGameBloc>(context)
                    .add(NeutralEvent());
                return gui(_listPlayers);
              } else if (state is QuitMultipleplayerGameState) {
                return gui([]);
              } else if (state is NeutralState) {
                print("vvvvvvvvvvvvvvv=" + _timeTillGameStarts.toString());
                return gui(_listPlayers);
              } else {
                return gui([_listPlayers]);
              }
            },
          )),
    );
  }
}
