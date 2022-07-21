import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buttonBack(BuildContext context) {
  return IconButton(
    icon: const Icon(
      Icons.arrow_back,
      size: 32,
      color: Colors.blue,
    ),
    onPressed: () {
      BlocProvider.of<LobbyBloc>(context).add(const ReturningLobbyEvent());
      Navigator.pop(context);
    },
  );
}
