import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget selectorGroupType(BuildContext context) {
  return Column(
    children: [
      gui(context),
    ],
  );
}

Widget gui(
  BuildContext context,
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
              backgroundColor: const Color.fromARGB(255, 112, 148, 209),
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
            print("aaaaaaaaaaaaaaaaaaaaa");
            //BlocProvider.of<SelectgroupBloc>(context)
            //.add(PressStartGameButtonEvent());
          },
        ),
      ),
      const SizedBox(height: 10.0),
      SizedBox(
        width: 200.0,
        child: TextButton(
          child: const Text("join_group").tr(),
          style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: const Color.fromARGB(255, 112, 148, 209),
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
            print("bbbbbbbbbbbbbbbbbbb");
            //BlocProvider.of<SelectgroupBloc>(context)
            //.add(PressStartGameButtonEvent());
          },
        ),
      ),
    ],
  );
}
