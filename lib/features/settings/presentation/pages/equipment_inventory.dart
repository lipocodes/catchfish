import 'dart:async';
import 'package:catchfish/core/widgets/main_menu.dart';
import 'package:catchfish/features/settings/presentation/blocs/bloc/inventory_bloc.dart';
import 'package:catchfish/features/settings/presentation/widgets/app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EquipmentInventory extends StatefulWidget {
  const EquipmentInventory({Key? key}) : super(key: key);

  @override
  State<EquipmentInventory> createState() => _EquipmentInventoryState();
}

class _EquipmentInventoryState extends State<EquipmentInventory> {
  bool _showedWarningYet = false;

  List localListInventory = [];

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
      Timer(const Duration(seconds: 1), () {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<InventoryBloc>(context).add(EnteringInventoryEvent());
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
              children: List.generate(state.inventoryScreenEntity.items.length,
                  (index) {
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(800),
                          child: Image.network(
                            state.inventoryScreenEntity.images[index],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                            state.inventoryScreenEntity.items[index].length > 24
                                ? state.inventoryScreenEntity.items[index]
                                    .substring(0, 24)
                                : state.inventoryScreenEntity.items[index],
                            style: const TextStyle(
                              fontSize: 28.0,
                              color: Colors.yellow,
                              fontFamily: 'skullsandcrossbones',
                            )),
                        Text(
                          "quantity".tr() +
                              state.inventoryScreenEntity.quantities[index]
                                  .toString(),
                          style: const TextStyle(
                            fontSize: 24.0,
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
