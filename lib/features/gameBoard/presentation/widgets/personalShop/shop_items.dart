import 'package:catchfish/features/fishingShop/domain/entities/retreive_shop_items_entity.dart';
import 'package:catchfish/features/fishingShop/presentation/blocs/bloc/fishingshop_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/bloc/fishing_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget shopItems(BuildContext context) {
  List<String> listItems = [];
  return BlocBuilder<FishingBloc, FishingState>(
    builder: (context, state) {
      if (state is LoadingPersonalShopState) {
        listItems = state.personalShopInventory;
        return gui(context, listItems);
      } else {
        return gui(context, listItems);
      }
    },
  );
}

Widget gui(BuildContext context, List<String> listItems) {
  List<String> title = [];
  List<String> price = [];
  List<String> weight = [];
  List<String> image = [];
  for (int a = 0; a < listItems.length; a++) {
    List<String> temp = listItems[a].split("^^^");
    title.add(temp[0]);
    price.add(temp[1]);
    weight.add(temp[2]);
    image.add(temp[3]);
  }
  return Container(
    height: MediaQuery.of(context).size.height,
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
            popup(context, title[index], image[index], price[index],
                weight[index]);
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
                    child: Image.asset(
                      'assets/images/gameBoard/fish/' + image[index],
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(title[index],
                      style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.yellow,
                        fontFamily: 'skullsandcrossbones',
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "weight".tr() + weight[index],
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.orange,
                          fontFamily: 'skullsandcrossbones',
                        ),
                      ),
                      Text(
                        "price".tr() + price[index],
                        style: const TextStyle(
                          fontSize: 24.0,
                          color: Colors.orange,
                          fontFamily: 'skullsandcrossbones',
                        ),
                      ),
                    ],
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

popup(BuildContext context, String title, String image, String price,
    String weight) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blue,
                  fontFamily: 'skullsandcrossbones',
                )).tr(),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: SizedBox(
          height: 250.0,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  'assets/images/gameBoard/fish/' + image,
                  width: 160,
                  height: 160,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'skullsandcrossbones',
                  fontSize: 30.0,
                  color: Colors.redAccent,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "price".tr() + price.toString(),
                    style: const TextStyle(
                      fontFamily: 'skullsandcrossbones',
                      fontSize: 24.0,
                      color: Colors.brown,
                    ),
                  ),
                  Text(
                    "weight".tr() + weight.toString(),
                    style: const TextStyle(
                      fontFamily: 'skullsandcrossbones',
                      fontSize: 24.0,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
