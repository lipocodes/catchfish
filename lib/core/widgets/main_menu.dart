import 'package:catchfish/features/fishingShop/presentation/pages/fishing_shop.dart';
import 'package:catchfish/features/settings/presentation/pages/equipment_inventory.dart';
import 'package:catchfish/features/tokens/presentation/pages/buy_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as UI;

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
                  fontSize: 20.0,
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
              Icons.token,
              color: Colors.greenAccent,
            ),
            title: Text('buy_tokens'.tr(),
                style: const TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'skullsandcrossbones',
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuyTokens()),
              );
            },
          ),
        ]),
      ),
    ),
  );
}
