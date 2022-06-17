import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/selectGroupBloc/selectgroup_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/selectGroup/button_start_game.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/selectGroup/selector_group_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectGroup extends StatefulWidget {
  const SelectGroup({Key? key}) : super(key: key);

  @override
  State<SelectGroup> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SelectGroup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            height: 1000,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  //tenor.com
                  'assets/images/gameBoard/palm.gif',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buttonStartGame(context),
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                selectorGroupType(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
