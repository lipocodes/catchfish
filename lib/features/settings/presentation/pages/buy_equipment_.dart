import 'dart:async';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/settings/presentation/blocs/bloc/inventory_bloc.dart';
import 'package:catchfish/features/settings/presentation/widgets/app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyEquipment extends StatefulWidget {
  const BuyEquipment({Key? key}) : super(key: key);

  @override
  State<BuyEquipment> createState() => _BuyEquipmentState();
}

class _BuyEquipmentState extends State<BuyEquipment> {
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
                          Navigator.pop(context);
                        })
                  ],
                ));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<InventoryBloc>(context).add(EnteringInventoryEvent());
  }

  performBack() {
    BlocProvider.of<LobbyBloc>(context).add(const ReturningLobbyEvent());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    showLoginWarning(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      //onDrawerChanged: (isOpened) {},
      appBar: appBar(context),
      //in core/widgets/main_menu.dart
      //drawer: mainMenu(context),
      body: WillPopScope(
        onWillPop: () => performBack(),
        child: Scaffold(
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
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text("buy_now",
                        style: TextStyle(
                          fontSize: 28.0,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontFamily: 'skullsandcrossbones',
                        )).tr(),
                    SizedBox(height: 600.0, child: productsToBuyGrid()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showDialogPurchaseResult(bool purchaseSuccessful) {
    Timer(const Duration(seconds: 1), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: purchaseSuccessful
                ? const Text("thank_you",
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.yellow,
                      fontFamily: 'skullsandcrossbones',
                    )).tr()
                : const Text("not_enough_money",
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.yellow,
                      fontFamily: 'skullsandcrossbones',
                    )).tr(),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  //performBack();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    });
  }

  productsToBuyGrid() {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        if (state is EnteringInventoryState) {
          return GridView.count(
            crossAxisCount: 1,
            childAspectRatio: (2),
            children: List.generate(
                state.inventoryScreenEntity.idItemsToSell.length, (index) {
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
                          state.inventoryScreenEntity.imageItemsToSell[index],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                          state.inventoryScreenEntity.titleItemsToSell[index]
                                      .length >
                                  24
                              ? state
                                  .inventoryScreenEntity.titleItemsToSell[index]
                                  .substring(0, 24)
                              : state.inventoryScreenEntity
                                  .titleItemsToSell[index],
                          style: const TextStyle(
                            fontSize: 28.0,
                            color: Colors.yellow,
                            fontFamily: 'skullsandcrossbones',
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "price".tr() +
                                state.inventoryScreenEntity
                                    .priceItemsToSell[index]
                                    .toString(),
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.blue,
                              fontFamily: 'skullsandcrossbones',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<InventoryBloc>(context)
                                  .add(BuyingItemEvent(indexItem: index));
                            },
                            child: Text(
                              "buy".tr(),
                              style: const TextStyle(
                                fontSize: 24.0,
                                color: Colors.red,
                                fontFamily: 'skullsandcrossbones',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        } else if (state is BuyingItemState) {
          if (state.enoughMoney) {
            showDialogPurchaseResult(true);
            BlocProvider.of<InventoryBloc>(context)
                .add(EnteringInventoryEvent());
          } else {
            showDialogPurchaseResult(false);
            BlocProvider.of<InventoryBloc>(context)
                .add(EnteringInventoryEvent());
          }
          return Container();
        } else {
          return Container();
        }
      },
    );
  }
}
