import 'dart:async';

import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/core/widgets/main_menu.dart';
import 'package:catchfish/features/settings/presentation/blocs/bloc/inventory_bloc.dart';
import 'package:catchfish/features/settings/presentation/widgets/app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EquipmentInventory extends StatefulWidget {
  const EquipmentInventory({Key? key}) : super(key: key);

  @override
  State<EquipmentInventory> createState() => _EquipmentInventoryState();
}

class _EquipmentInventoryState extends State<EquipmentInventory> {
  late PlaySound playSound;
  bool _showedWarningYet = false;
  List<String> images = [];
  List<String> items = [];
  List<int> quatities = [];
  late SharedPreferences prefs;

  getGridViewItems(BuildContext context, String gridItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(gridItem),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showLoginWarning(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null && _showedWarningYet == false) {
      _showedWarningYet = true;
      Timer(const Duration(seconds: 3), () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text('not_logged_in').tr(),
                  content: const Text('text_not_logged_in').tr(),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ));
      });
    }
  }

  //custom BACK operation
  performBack() async {
    Navigator.pop(context, true);
    Navigator.pop(context, true);
    Navigator.pushNamed(context, '/');
  }

  initilizePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initilizePrefs();
    BlocProvider.of<InventoryBloc>(context).add(EnteringInventoryEvent());

    playSound = PlaySound();
    playSound.play(
      path: "assets/sounds/settings/",
      fileName: "bubbles.mp3",
    );
  }

  @override
  Widget build(BuildContext context) {
    showLoginWarning(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      onDrawerChanged: (isOpened) {},
      appBar: appBar(context),
      //in core/widgets/main_menu.dart
      drawer: mainMenu(context),
      body: inventoryGrid(),
    );
  }

  Widget inventoryGrid() {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        if (state is EnteringInventoryState) {
          images = [];
          items = [];
          quatities = [];
          List localListInventory = prefs.getStringList("inventory") ?? [];
          //going over inventory items saved on DB
          for (int a = 0; a < state.inventoryEntity.listInventory.length; a++) {
            String temp = state.inventoryEntity.listInventory[a];
            List<String> list1 = temp.split("^^^");
            temp = localListInventory[a];
            List<String> list2 = temp.split("^^^");
            int lastUpdateInventoryDB = int.parse(list1[3]);
            int lastUpdateInventoryPrefs = int.parse(list2[3]);
            //only if item exits on both DB & Prefs & item on DB is newer, show it to the user
            if (lastUpdateInventoryDB > lastUpdateInventoryPrefs) {
              images.add(list1[0]);
              items.add(list1[1]);
              quatities.add(int.parse(list1[2]));
            } else {
              images.add(list2[0]);
              items.add(list2[1]);
              quatities.add(int.parse(list2[2]));
            }
          }
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  //tenor.com
                  'assets/images/settings/bubbles.gif',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: GridView.count(
              crossAxisCount: 1,
              childAspectRatio: (2),
              children: List.generate(items.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        // Red border with the width is equal to 5
                        border: Border.all(width: 3, color: Colors.grey)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 64,
                            height: 64,
                            child: Image.network(images[index])),
                        Text(
                            items[index].length > 24
                                ? items[index].substring(0, 24)
                                : items[index],
                            style: const TextStyle(
                              fontSize: 28.0,
                              color: Colors.yellow,
                              fontFamily: 'skullsandcrossbones',
                            )),
                        Text(
                          "quantity".tr() + quatities[index].toString(),
                          style: const TextStyle(
                            fontSize: 28.0,
                            color: Colors.white,
                            fontFamily: 'skullsandcrossbones',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
