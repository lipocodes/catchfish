import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/tokens/presentation/widgets/button_back.dart';
import 'package:catchfish/features/tokens/presentation/widgets/prod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget listProds(state, BuildContext context) {
  //custom BACK operation
  Future<bool> performBack() async {
    BlocProvider.of<LobbyBloc>(context).add(const ReturningLobbyEvent());
    Navigator.pop(context);
    return true;
  }

  return Directionality(
    textDirection: TextDirection.ltr,
    child: SafeArea(
      child: WillPopScope(
        onWillPop: performBack,
        child: Scaffold(
          body: Container(
              height: 1000,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    //tenor.com
                    'assets/images/tokens/skeleton.gif',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buttonBack(performBack),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  prod(state, 0, context),
                  prod(state, 1, context),
                  prod(state, 2, context),
                ],
              )),
        ),
      ),
    ),
  );
}
