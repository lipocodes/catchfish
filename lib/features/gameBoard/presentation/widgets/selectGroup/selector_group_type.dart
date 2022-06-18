import 'package:catchfish/features/gameBoard/domain/usecases/fishing/selectGroup_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/selectGroupBloc/selectgroup_bloc.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

TextEditingController groupNameController = TextEditingController();
TextEditingController yourNameController = TextEditingController();
List<String> listGroups = [];

Widget selectorGroupType(BuildContext context) {
  return BlocBuilder<SelectgroupBloc, SelectgroupState>(
    builder: (context, state) {
      if (state is SelectgroupInitial) {
        BlocProvider.of<SelectgroupBloc>(context).add(EnteringScreenEvent(
            selectGroupUsecase: sl.get<SelectGroupUsecase>()));
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
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: 250.0,
            height: 50.0,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 73, 164, 224),
                borderRadius: BorderRadius.all(Radius.circular(20))),
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
                labelText: ' Your Name ',
              ),
              onChanged: (text) {
                print("sss=" + groupNameController.text);
                BlocProvider.of<SelectgroupBloc>(context).add(
                    YourNameChangedEvent(
                        yourName: yourNameController.text,
                        selectedGroup: groupNameController.text));
              },
            ),
          ),
        ),
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
              width: 250.0,
              height: 50.0,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 73, 164, 224),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: TextField(
                controller: groupNameController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: 'skullsandcrossbones',
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: ' Group Name ',
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (text) {
                  BlocProvider.of<SelectgroupBloc>(context).add(
                      GroupNameChangedEvent(
                          groupName: groupNameController.text));
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
              if (state is EnteringScreenState) {
                listGroups = state.listGroups;

                return listView(context, state.selectedGroup);
              } else if (state is SelectedGroupState) {
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
