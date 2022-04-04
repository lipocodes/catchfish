import 'dart:async';
import 'package:catchfish/core/utils/here_working.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/introduction/presentation/widgets/boat_steering.dart';
import 'package:catchfish/features/introduction/presentation/widgets/flying_bird.dart';
import 'package:catchfish/features/introduction/presentation/widgets/text_loading.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> with SingleTickerProviderStateMixin {
  late LobbyBloc _lobbyBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _lobbyBloc = LobbyBloc();
    _lobbyBloc.add(const EnteringLobbyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LobbyBloc, LobbyState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(children: [hereWorking("כאן יקום מסך לובי")]),
          ),
        );
      },
    );
  }
}
