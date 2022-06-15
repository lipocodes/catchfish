import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/selectGroupBloc/selectgroup_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

TextEditingController groupNameController = TextEditingController();
TextEditingController yourNameController = TextEditingController();

Widget selectorGroupType(BuildContext context) {
  return BlocBuilder<SelectgroupBloc, SelectgroupState>(
    builder: (context, state) {
      if (state is SelectgroupInitial) {
        return Column(
          children: [
            gui(context, 0),
          ],
        );
      } else if (state is SelectedGroupTypeState) {
        BlocProvider.of<SelectgroupBloc>(context).add(NeutralEvent());
        return Column(
          children: [
            gui(context, state.selectedGroupType),
          ],
        );
      } else if (state is GroupNameValueState) {
        groupNameController.text = state.groupName;
        return Column(children: [
          gui(context, state.selectedGroupType),
        ]);
      } else if (state is YourNameValueState) {
        yourNameController.text = state.yourName;
        return Column(children: [
          gui(context, state.selectedGroupType),
        ]);
      } else if (state is NeutralState) {
        return Column(children: [
          gui(context, state.selectedGroupType),
        ]);
      } else {
        return Container();
      }
    },
  );
}

Widget gui(
  BuildContext context,
  int selectedGroupType,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Center(
        child: Text(
          "please_select_option".tr(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.red,
            fontStyle: FontStyle.italic,
            fontFamily: 'skullsandcrossbones',
          ),
        ),
      ),
      SizedBox(
        width: 200.0,
        child: TextButton(
          child: const Text("start_group").tr(),
          style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: selectedGroupType == 1
                  ? const Color.fromARGB(255, 112, 148, 209)
                  : Colors.grey,
              elevation: 20,
              shadowColor: Colors.red,
              //shape: const CircleBorder(),
              //padding: const EdgeInsets.all(10),
              textStyle: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontFamily: 'skullsandcrossbones',
              )),
          onPressed: () {
            BlocProvider.of<SelectgroupBloc>(context)
                .add(const PressButtonGroupTypeEvent(selectedGroupType: 1));
          },
        ),
      ),
      if (selectedGroupType == 1) ...[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: groupNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Group Name',
            ),
            onChanged: (text) {
              BlocProvider.of<SelectgroupBloc>(context).add(
                  GroupNameChangedEvent(groupName: groupNameController.text));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: yourNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Your Name',
            ),
            onChanged: (text) {
              BlocProvider.of<SelectgroupBloc>(context)
                  .add(YourNameChangedEvent(yourName: yourNameController.text));
            },
          ),
        ),
      ],
      const SizedBox(height: 10.0),
      SizedBox(
        width: 200.0,
        child: TextButton(
          child: const Text("join_group").tr(),
          style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: selectedGroupType == 2
                  ? const Color.fromARGB(255, 112, 148, 209)
                  : Colors.grey,
              elevation: 20,
              shadowColor: Colors.red,
              //shape: const CircleBorder(),
              //padding: const EdgeInsets.all(10),
              textStyle: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontFamily: 'skullsandcrossbones',
              )),
          onPressed: () {
            BlocProvider.of<SelectgroupBloc>(context)
                .add(const PressButtonGroupTypeEvent(selectedGroupType: 2));
          },
        ),
      ),
    ],
  );
}