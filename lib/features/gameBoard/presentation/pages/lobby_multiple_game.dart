import 'dart:async';

import 'package:catchfish/features/gameBoard/presentation/blocs/multiplayer/lobby_multiplayer_game_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/fishing.dart';
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
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    //add event: join existibg group for a game OR craete a new one
    BlocProvider.of<LobbyMultiplayerGameBloc>(context)
        .add(JoinMultipleplayerGameEvent());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      BlocProvider.of<LobbyMultiplayerGameBloc>(context)
          .add(GetUpdateMultipleplayerGameEvent());
    });
  }

  performBack() {
    _timer.cancel();
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
          const SizedBox(height: 20.0),
          Text(((_timeTillGameStarts) / 1000).floor().toString(),
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontFamily: 'skullsandcrossbones',
              )),
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
              if (state is JoinMultipleplayerGameState) {
                return gui([]);
              } else if (state is GetUpdateMultipleplayerGameState) {
                _listPlayers = state.multipleplayerEntity.playersInGroup;
                _timeTillGameStarts =
                    state.multipleplayerEntity.timeTillStartGame;

                if (_timeTillGameStarts < 2000 && _timeTillGameStarts > 0) {
                  _timer.cancel();
                  Timer(const Duration(seconds: 1), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Fishing()),
                    );
                  });
                }
                BlocProvider.of<LobbyMultiplayerGameBloc>(context)
                    .add(NeutralEvent());
                return gui(_listPlayers);
              } else if (state is QuitMultipleplayerGameState) {
                return gui([]);
              } else if (state is NeutralState) {
                return gui(_listPlayers);
              } else {
                return gui([_listPlayers]);
              }
            },
          )),
    );
  }
}
