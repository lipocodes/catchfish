import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget mainMenu(BuildContext context) {
  return Drawer(
    child: ListView(children: [
      ListTile(
        title: Text('equipment_storage'.tr()),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ]),
  );
}
