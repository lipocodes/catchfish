import 'package:catchfish/core/widgets/main_menu.dart';
import 'package:catchfish/features/fishingShop/domain/entities/retreive_shop_items_entity.dart';
import 'package:catchfish/features/fishingShop/presentation/blocs/bloc/fishingshop_bloc.dart';
import 'package:catchfish/features/fishingShop/presentation/widgets/app_bar.dart';
import 'package:catchfish/features/fishingShop/presentation/widgets/inventory.dart';
import 'package:catchfish/features/fishingShop/presentation/widgets/shop_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FishingShop extends StatefulWidget {
  const FishingShop({Key? key}) : super(key: key);

  @override
  State<FishingShop> createState() => _FishingShopState();
}

class _FishingShopState extends State<FishingShop> {
  List<RetreiveShopItemsEntity> _listItems = [];
  int _inventoryMoney = 0;
  int _inventoryBaits = 0;
  int _inventoryXP = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FishingshopBloc>(context).add(EnteringShopEvent());
    BlocProvider.of<FishingshopBloc>(context).add(RetreiveShopItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FishingshopBloc, FishingshopState>(
      builder: (context, state) {
        if (state is RetreiveShopItemsState) {
          _listItems = state.listItems;
        } else if (state is EnteringShopState) {
          _inventoryMoney = state.retreivePrizeEntity.inventoryMoney;
          _inventoryBaits = state.retreivePrizeEntity.inventoryBaits;
          _inventoryXP = state.retreivePrizeEntity.inventoryXP;
        } else if (state is BuyItemWithMoneyPrizeState) {
          _inventoryMoney = state.inventoryMoney;
          _inventoryBaits = state.inventoryBaits;
          _inventoryXP = state.inventoryXP;
        }
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            onDrawerChanged: (isOpened) {},
            appBar: appBar(context),
            //in core/widgets/main_menu.dart
            drawer: mainMenu(context),
            body: Column(
              children: [
                const SizedBox(
                  height: 50.0,
                ),
                inventory(
                    context, _inventoryMoney, _inventoryBaits, _inventoryXP),
                shopItems(_listItems, context),
              ],
            ),
          ),
        );
      },
    );
  }
}
