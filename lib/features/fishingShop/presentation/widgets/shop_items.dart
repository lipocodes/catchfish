import 'package:catchfish/features/fishingShop/domain/entities/retreive_shop_items_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget shopItems(
    List<RetreiveShopItemsEntity> listItems, BuildContext context) {
  popup(String id, String image, String title, String subtitle,
      double price) async {
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
            height: 270.0,
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
                    fontSize: 28.0,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
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
                      )),
                ),
                ElevatedButton(
                    child: const Text("Buy",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontFamily: 'skullsandcrossbones',
                        )).tr(),
                    onPressed: () {
                      print("xxxxxxxxxxxxxxxxxxxx");
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    )),
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
      crossAxisCount: 2,
      childAspectRatio: (1),
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
                      listItems[index].title.length > 10
                          ? listItems[index].title.substring(0, 10)
                          : listItems[index].title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.yellow,
                        fontFamily: 'skullsandcrossbones',
                      )),
                  Text(
                    "price".tr() + listItems[index].price.toString(),
                    style: const TextStyle(
                      fontSize: 20.0,
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
