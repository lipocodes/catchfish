import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/core/widgets/main_menu.dart';
import 'package:catchfish/features/settings/presentation/widgets/button_back.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EquipmentInventory extends StatefulWidget {
  const EquipmentInventory({Key? key}) : super(key: key);

  @override
  State<EquipmentInventory> createState() => _EquipmentInventoryState();
}

class _EquipmentInventoryState extends State<EquipmentInventory> {
  late PlaySound playSound;
  List images = [
    "assets/images/lobby/scroll.jpg",
    "assets/images/lobby/scroll.jpg"
  ];
  List<String> items = [
    'Baits',
    'abcdefghijklmnopqrstuvwx',
  ];
  List<int> quatities = [5, 3];

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

  //custom BACK operation
  performBack() async {
    Navigator.pop(context, true);
    Navigator.pop(context, true);
    Navigator.pushNamed(context, '/');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    playSound = PlaySound();
    playSound.play(
      path: "assets/sounds/settings/",
      fileName: "bubbles.mp3",
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      extendBodyBehindAppBar: true,
      onDrawerChanged: (isOpened) {},
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  if (auth.currentUser != null) {
                    await FirebaseAuth.instance.signOut();
                    performBack();
                  } else {
                    await Navigator.pushNamed(context, '/login');
                    performBack();
                  }
                },
                child: Text(
                    auth.currentUser == null ? "Login".tr() : "Logout".tr(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 24.0,
                      fontFamily: 'skullsandcrossbones',
                    )),
              ),
              const SizedBox(
                width: 100,
              ),
              buttonBack(context),
            ],
          ),
        ],
      ),
      //in core/widgets/main_menu.dart
      drawer: mainMenu(context),
      body: Container(
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
                        child: Image.asset(images[index])),
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
      ),
    );
  }
}
