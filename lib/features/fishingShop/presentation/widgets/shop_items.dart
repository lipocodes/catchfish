import 'package:catchfish/features/fishingShop/domain/entities/retreive_shop_items_entity.dart';
import 'package:catchfish/features/fishingShop/presentation/blocs/bloc/fishingshop_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget shopItems(
    List<RetreiveShopItemsEntity> listItems, BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.8,
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
      crossAxisCount: 2,
      childAspectRatio: (1),
      children: List.generate(listItems.length, (index) {
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
                    listItems[index].image,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                    listItems[index].title.length > 10
                        ? listItems[index].title.substring(0, 10)
                        : listItems[index].title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.yellow,
                      fontFamily: 'skullsandcrossbones',
                    )),
                Text(
                  "quantity".tr() + listItems[index].quantity.toString(),
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.yellow,
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
}
