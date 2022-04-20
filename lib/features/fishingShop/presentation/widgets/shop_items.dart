import 'package:catchfish/features/fishingShop/domain/entities/retreive_shop_items_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget shopItems(
    List<RetreiveShopItemsEntity> listItems, BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.8,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          //tenor.com
          'assets/images/fishingShop/bubbles.gif',
        ),
        fit: BoxFit.cover,
      ),
    ),
    child: GridView.count(
      padding: EdgeInsets.zero,
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
                  borderRadius: BorderRadius.circular(400),
                  /*child: CachedNetworkImage(
                    width: 64,
                    height: 64,
                    imageUrl: listItems[index].image,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),*/
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
                      fontSize: 24.0,
                      color: Colors.yellow,
                      fontFamily: 'skullsandcrossbones',
                    )),
                Text(
                  "price".tr() + listItems[index].price.toString(),
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.orange,
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
