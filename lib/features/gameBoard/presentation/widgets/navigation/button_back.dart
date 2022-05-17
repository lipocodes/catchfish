import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buttonBack(BuildContext context) {
  return IconButton(
    icon: const Icon(
      Icons.arrow_back,
      size: 28,
      color: Colors.blue,
    ),
    onPressed: () {
      BlocProvider.of<NavigationBloc>(context).add(LeavingNavigationEvent());
      Navigator.pop(context);
    },
  );
}
