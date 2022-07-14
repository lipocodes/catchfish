import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

PreferredSizeWidget appBar(BuildContext context) {
  //custom BACK operation
  performBack(BuildContext context) async {
    BlocProvider.of<LobbyBloc>(context).add(const ReturningLobbyEvent());
    Navigator.pop(context);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leadingWidth: 100,
    leading: ElevatedButton.icon(
      onPressed: () => performBack(context),
      icon: const Icon(Icons.arrow_left),
      label: const Text('Back'),
      style:
          ElevatedButton.styleFrom(elevation: 0, primary: Colors.transparent),
    ),
  );
}
