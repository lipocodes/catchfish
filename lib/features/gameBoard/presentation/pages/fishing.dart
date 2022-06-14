import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/bloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/game.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/select_group.dart';
import 'package:catchfish/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Fishing extends StatefulWidget {
  const Fishing({Key? key}) : super(key: key);

  @override
  State<Fishing> createState() => _FishingState();
}

class _FishingState extends State<Fishing> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FishingBloc>(context).add(EnteringScreenEvent(
      fishingUsecase: sl.get<FishingUsecase>(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        home: BlocBuilder<FishingBloc, FishingState>(
          builder: (context, state) {
            if (state is EnteringScreenState) {
              return Scaffold(body: selectGroup(context));
            } else if (state is StartingGameState) {
              return Scaffold(body: game(context));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
