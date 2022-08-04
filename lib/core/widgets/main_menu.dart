import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/personal_collection.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/personal_shop.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/select_group.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/settings/presentation/pages/buy_equipment_.dart';
import 'package:catchfish/features/settings/presentation/pages/contact.dart';
import 'package:catchfish/features/settings/presentation/pages/equipment_inventory.dart';
import 'package:catchfish/features/tokens/presentation/pages/buy_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Warning: player has less than 5 baits, which may result in game premature end
showBaitNumberWarning(BuildContext context) async {
  late PlaySound playSound;
  playSound = PlaySound();
  playSound.play(
    path: "assets/sounds/lobby/",
    fileName: "beep.mp3",
  );
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "title_bait_number_warning",
          style: TextStyle(
            fontFamily: 'skullsandcrossbones',
          ),
        ).tr(),
        content: const Text(
          "body_bait_number_warning",
          style: TextStyle(
            fontFamily: 'skullsandcrossbones',
          ),
        ).tr(),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelectGroup()),
              );
            },
            child: const Text('OK',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blue,
                  fontFamily: 'skullsandcrossbones',
                )),
          ),
        ],
      );
    },
  );
}

Widget mainMenu(BuildContext context) {
  UI.TextDirection direction = UI.TextDirection.ltr;
  return Directionality(
    textDirection: direction,
    child: Drawer(
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            selected: true,
            selectedTileColor: Colors.grey[300],
            tileColor: Colors.blue,
            leading: const Icon(
              Icons.directions_boat_outlined,
              color: Colors.greenAccent,
            ),
            title: Text('play_game'.tr(),
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'skullsandcrossbones',
                )),
            onTap: () async {
              //Navigator.pop(context);
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              int inventoryBaits = _prefs.getInt("inventoryBaits") ?? 0;
              if (inventoryBaits < 5) {
                showBaitNumberWarning(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectGroup()),
                );
              }
            },
          ),
          const Divider(
            color: Colors.black38,
            thickness: 5,
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            selected: true,
            selectedTileColor: Colors.grey[300],
            tileColor: Colors.blue,
            leading: const Icon(
              Icons.business,
              color: Colors.greenAccent,
            ),
            title: Text('buy_equipment'.tr(),
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'skullsandcrossbones',
                )),
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushNamed(context, '/equipment_inventory');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuyEquipment()),
              );
            },
          ),
          const Divider(
            color: Colors.black38,
            thickness: 5,
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            selected: true,
            selectedTileColor: Colors.grey[300],
            tileColor: Colors.blue,
            leading: const Icon(
              Icons.inventory,
              color: Colors.greenAccent,
            ),
            title: Text('my_equipment'.tr(),
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'skullsandcrossbones',
                )),
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushNamed(context, '/equipment_inventory');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EquipmentInventory()),
              );
            },
          ),
          const Divider(
            color: Colors.black38,
            thickness: 5,
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            selected: true,
            selectedTileColor: Colors.grey[300],
            tileColor: Colors.blue,
            leading: const Icon(
              Icons.person,
              color: Colors.greenAccent,
            ),
            title: Text('personal_shop'.tr(),
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'skullsandcrossbones',
                )),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalShop()),
              );
            },
          ),
          const Divider(
            color: Colors.black38,
            thickness: 5,
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            selected: true,
            selectedTileColor: Colors.grey[300],
            tileColor: Colors.blue,
            leading: const Icon(
              Icons.person,
              color: Colors.greenAccent,
            ),
            title: Text('personal_collection'.tr(),
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'skullsandcrossbones',
                )),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PersonalCollection()),
              );
            },
          ),
          const Divider(
            color: Colors.black38,
            thickness: 5,
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            selected: true,
            selectedTileColor: Colors.grey[300],
            tileColor: Colors.blue,
            leading: const Icon(
              Icons.currency_bitcoin,
              color: Colors.greenAccent,
            ),
            title: Text('buy_tokens'.tr(),
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'skullsandcrossbones',
                )),
            onTap: () async {
              Navigator.pop(context);
              BlocProvider.of<LobbyBloc>(context).add(LeavingLobbyEvent());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuyToken()),
              );
              //Navigator.pop(context, true);
              //Navigator.pushNamed(context, '/');
            },
          ),
          const Divider(
            color: Colors.black38,
            thickness: 5,
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            selected: true,
            selectedTileColor: Colors.grey[300],
            tileColor: Colors.blue,
            leading: const Icon(
              Icons.mail,
              color: Colors.greenAccent,
            ),
            title: Text('contact'.tr(),
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'skullsandcrossbones',
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Contact()),
              );
            },
          ),
        ]),
      ),
    ),
  );
}
