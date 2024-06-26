import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/selectGroupBloc/selectgroup_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/selectGroup/button_multiplayer_game.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/selectGroup/button_start_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as UI;

TextEditingController groupNameController = TextEditingController();
TextEditingController yourNameController = TextEditingController();
List<String> listGroups = [];

Widget selectorGroupType(BuildContext context, String playerName) {
  yourNameController.text = playerName;
  int selectedGroupType = 0;
  return BlocBuilder<SelectgroupBloc, SelectgroupState>(
    builder: (context, state) {
      if (state is SelectgroupInitial) {
        return Column(
          children: [
            gui(context, 0),
          ],
        );
      } else if (state is EnteringScreenState) {
        listGroups = state.listGroups;
        return Column(
          children: [
            gui(context, 0),
          ],
        );
      } else if (state is SelectedGroupTypeState) {
        selectedGroupType = state.selectedGroupType;
        BlocProvider.of<SelectgroupBloc>(context).add(NeutralEvent());
        return Column(
          children: [
            gui(context, selectedGroupType),
          ],
        );
      } else if (state is GroupNameValueState) {
        groupNameController.text = state.groupName;
        BlocProvider.of<SelectgroupBloc>(context).add(NeutralEvent());
        return Column(children: [
          gui(context, selectedGroupType),
        ]);
      } else if (state is YourNameValueState) {
        yourNameController.text = state.yourName;
        BlocProvider.of<SelectgroupBloc>(context).add(NeutralEvent());
        return Column(children: [
          gui(context, selectedGroupType),
        ]);
      } else if (state is NeutralState) {
        return Column(children: [
          gui(context, selectedGroupType),
        ]);
      } else if (state is SelectedGroupState) {
        return Column(children: [
          gui(context, selectedGroupType),
        ]);
      } else {
        return Column(children: [
          gui(context, selectedGroupType),
        ]);
      }
    },
  );
}

Widget gui(
  BuildContext context,
  int selectedGroupType,
) {
  UI.TextDirection direction = UI.TextDirection.ltr;
  return Center(
    child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 100.00),
        buttonStartGame(context),
        const SizedBox(
          height: 20.0,
        ),
        buttonMultiplayerGame(context),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          width: 250.0,
          height: 50.0,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 60, 115, 151),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Directionality(
            textDirection: direction,
            child: TextField(
              controller: yourNameController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontFamily: 'skullsandcrossbones',
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: InputBorder.none,
                //labelText: playerName,
              ),
              onChanged: (text) {
                if (yourNameController.text.isEmpty) {
                  yourNameController.text = "Must Have a Value!";
                }
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget listView(BuildContext context, String selectedGroup) {
  return SizedBox(
    height: 200.0,
    child: ListView.builder(
        itemCount: listGroups.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              onTap: () {
                BlocProvider.of<SelectgroupBloc>(context).add(
                    SelectedExistingGroupEvent(
                        selectedGroup: listGroups[index]));
              },
              title: Center(
                child: Text(
                  listGroups[index],
                  style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'skullsandcrossbones',
                      backgroundColor: listGroups[index] == selectedGroup
                          ? Colors.blueAccent
                          : Colors.transparent),
                ),
              ));
        }),
  );
}
