import 'package:catchfish/features/fishingShop/domain/entities/retreive_shop_items_entity.dart';
import 'package:catchfish/features/fishingShop/presentation/blocs/bloc/fishingshop_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget shopItems(
    List<RetreiveShopItemsEntity> listItems, BuildContext context) {
  popup(
      String id, String image, String title, String subtitle, int price) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int inventoryMoney = prefs.getInt("inventoryMoney") ?? 0;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            height: 300.0,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    image,
                    width: 160,
                    height: 160,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  title.length > 20 ? title.substring(0, 20) : title,
                  style: const TextStyle(
                    fontFamily: 'skullsandcrossbones',
                    fontSize: 24.0,
                    color: Colors.redAccent,
                  ),
                ),
                Text(
                  subtitle.length > 20 ? subtitle.substring(0, 20) : subtitle,
                  style: const TextStyle(
                    fontFamily: 'skullsandcrossbones',
                    fontSize: 20.0,
                    color: Colors.orangeAccent,
                  ),
                ),
                Text(
                  "price".tr() + price.toString(),
                  style: const TextStyle(
                    //fontFamily: 'skullsandcrossbones',
                    fontSize: 24.0,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.blue,
                            fontFamily: 'skullsandcrossbones',
                          )).tr(),
                    ),
                    if (price <= inventoryMoney) ...[
                      ElevatedButton(
                          child: const Text("Buy",
                              style: TextStyle(
                                fontSize: 26.0,
                                fontFamily: 'skullsandcrossbones',
                              )).tr(),
                          onPressed: () {
                            if (price <= inventoryMoney) {
                              BlocProvider.of<FishingshopBloc>(context).add(
                                  BuyItemWithMoneyPrizeEvent(
                                      id: id,
                                      image: image,
                                      title: title,
                                      price: price));
                            }
                            Navigator.of(context)
                                .popUntil(ModalRoute.withName("/"));
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          )),
                    ],
                  ],
                ),
                Text(
                  (price <= inventoryMoney) ? "" : "not_enough_tokens".tr(),
                  style: TextStyle(
                    //fontFamily: 'skullsandcrossbones',
                    fontSize: 16.0,
                    color:
                        (price <= inventoryMoney) ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

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
      crossAxisCount: 1,
      childAspectRatio: 2,
      children: List.generate(listItems.length, (index) {
        return GestureDetector(
          onTap: () {
            popup(
                listItems[index].id,
                listItems[index].image,
                listItems[index].title,
                listItems[index].subtitle,
                listItems[index].price);
          },
          child: Padding(
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
                    child: Image.network(
                      listItems[index].image,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                      listItems[index].title.length > 20
                          ? listItems[index].title.substring(0, 20)
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
          ),
        );
      }).toList(),
    ),
  );
}
