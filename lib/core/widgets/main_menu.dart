import 'package:catchfish/features/fishingShop/presentation/pages/fishing_shop.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/navigation.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/personal_shop.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/settings/presentation/pages/contact.dart';
import 'package:catchfish/features/settings/presentation/pages/equipment_inventory.dart';
import 'package:catchfish/features/tokens/presentation/pages/buy_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as UI;

import 'package:flutter_bloc/flutter_bloc.dart';

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
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushNamed(context, '/main_game_board');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Navigation()),
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
            title: Text('equipment_storage'.tr(),
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
              Icons.add_shopping_cart,
              color: Colors.greenAccent,
            ),
            title: Text('fishing_shop'.tr(),
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
                MaterialPageRoute(builder: (context) => const FishingShop()),
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
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuyToken()),
              );
              Navigator.pop(context, true);
              Navigator.pushNamed(context, '/');
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
