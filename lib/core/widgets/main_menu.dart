import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget mainMenu(BuildContext context) {
  return Drawer(
    elevation: 5,
    backgroundColor: Colors.blue.shade900,
    child: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/waves.gif"),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(children: [
        ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          selected: true,
          selectedTileColor: Colors.grey[300],
          tileColor: Colors.blue,
          leading: const Icon(
            Icons.inventory,
            color: Colors.greenAccent,
          ),
          title: Text('equipment_storage'.tr(),
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: 'skullsandcrossbones',
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const Divider(
          color: Colors.black38,
          thickness: 5,
        )
      ]),
    ),
  );
}
