import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/selectGroupBloc/selectgroup_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

TextEditingController groupNameController = TextEditingController();
TextEditingController yourNameController = TextEditingController();
List<String> listGroups = [
  "Group1",
  "Group2",
  "Group3",
  "Group4",
  "Group5",
  "Group6",
  "Group7"
];

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
      } else if (state is SelectedGroupState) {
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
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 100.00),
        SizedBox(
          width: 250.0,
          child: TextButton(
            child: const Text("start_group").tr(),
            style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: selectedGroupType == 1
                    ? const Color.fromARGB(255, 112, 148, 209)
                    : Colors.grey,
                elevation: 20,
                shadowColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                textStyle: const TextStyle(
                  fontSize: 24,
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
            child: Container(
              color: Color.fromARGB(255, 73, 164, 224),
              child: TextField(
                controller: groupNameController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: 'skullsandcrossbones',
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group Name',
                ),
                onChanged: (text) {
                  BlocProvider.of<SelectgroupBloc>(context).add(
                      GroupNameChangedEvent(
                          groupName: groupNameController.text));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              color: Color.fromARGB(255, 73, 164, 224),
              child: TextField(
                controller: yourNameController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: 'skullsandcrossbones',
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Name',
                ),
                onChanged: (text) {
                  BlocProvider.of<SelectgroupBloc>(context).add(
                      YourNameChangedEvent(yourName: yourNameController.text));
                },
              ),
            ),
          ),
        ],
        const SizedBox(height: 10.0),
        SizedBox(
          width: 250.0,
          child: TextButton(
            child: const Text("join_group").tr(),
            style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: selectedGroupType == 2
                    ? const Color.fromARGB(255, 112, 148, 209)
                    : Colors.grey,
                elevation: 20,
                shadowColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'skullsandcrossbones',
                )),
            onPressed: () {
              BlocProvider.of<SelectgroupBloc>(context)
                  .add(const PressButtonGroupTypeEvent(selectedGroupType: 2));
            },
          ),
        ),
        if (selectedGroupType == 2) ...[
          BlocBuilder<SelectgroupBloc, SelectgroupState>(
            builder: (context, state) {
              if (state is SelectedGroupState) {
                BlocProvider.of<SelectgroupBloc>(context).add(NeutralEvent());
                return listView(context, state.selectedGroup);
              } else if (state is NeutralState) {
                return listView(context, state.selectedGroup);
              } else {
                return Container();
              }
            },
          ),
        ],
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
