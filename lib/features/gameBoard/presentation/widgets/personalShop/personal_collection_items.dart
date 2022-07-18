import 'dart:async';

import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget personalCollectionItems(
  BuildContext context,
) {
  List<String> listItems = [];
  String emailSeller = "";
  return BlocBuilder<FishingBloc, FishingState>(
    builder: (context, state) {
      if (state is LoadingPersonalCollectionState) {
        listItems = state.personalCollectionInventory;

        emailSeller = state.email;
        return gui(context, listItems, emailSeller);
      } else if (state is RejectPriceOfferState) {
        List listItems = state.listItems;
        return gui(context, listItems, "");
      } else if (state is AcceptPriceOfferState) {
        List listItems = state.listItems;
        return gui(context, listItems, "");
      } else if (state is SendPriceOfferCollectionFishState) {
        Timer(const Duration(seconds: 1), () {
          SnackBar snackBar = SnackBar(
            content: Text('price_offer_sent'.tr(),
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 20.0,
                  fontFamily: 'skullsandcrossbones',
                )),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        return gui(context, listItems, emailSeller);
      } else if (state is AcceptPriceOfferCollectionFishState) {
        Timer(const Duration(seconds: 1), () {
          SnackBar snackBar = SnackBar(
            content: Text(state.success ? 'fish_sold'.tr() : "not_enough_money",
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 20.0,
                  fontFamily: 'skullsandcrossbones',
                )),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          final fishingUsecase = sl.get<FishingUsecase>();
          BlocProvider.of<FishingBloc>(context).add(
              LoadingPersonalCollectionEvent(
                  fishingUsecase: fishingUsecase, email: ""));
        });

        return gui(context, listItems, emailSeller);
      } else {
        return gui(context, listItems, "");
      }
    },
  );
}

Widget gui(BuildContext context, List listItems, String email) {
  List<String> title = [];
  List<String> price = [];
  List<String> weight = [];
  List<String> image = [];
  List<String> emailBuyer = [];

  for (int a = 0; a < listItems.length; a++) {
    List<String> temp = listItems[a].split("^^^");
    title.add(temp[0]);
    price.add(temp[1]);
    weight.add(temp[2]);
    image.add(temp[3]);
    emailBuyer.add(temp[6]);
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
                      if (email.isEmpty) ...[
                        GestureDetector(
                          onTap: () {
                            popupSell(context, true, title[index], image[index],
                                price[index], index, email, emailBuyer[index]);
                          },
                          child: Text(
                            "bids".tr(),
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.red,
                              fontFamily: 'skullsandcrossbones',
                            ),
                          ),
                        )
                      ],
                      if (email.isNotEmpty) ...[
                        GestureDetector(
                          onTap: () {
                            popupSell(
                                context,
                                false,
                                title[index],
                                image[index],
                                price[index],
                                index,
                                email,
                                emailBuyer[index]);
                          },
                          child: Text(
                            "buy".tr(),
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.red,
                              fontFamily: 'skullsandcrossbones',
                            ),
                          ),
                        )
                      ],
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

popupSell(
    BuildContext context,
    bool isItMyCollection,
    String title,
    String image,
    String price,
    int index,
    String email,
    String emailBuyer) async {
  if (isItMyCollection) {
    //viewing existing bids on my fish
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('no_thanks',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.blue,
                        fontFamily: 'skullsandcrossbones',
                      )).tr(),
                ),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<FishingBloc>(context).add(
                        AcceptPriceOfferCollectionFishEvent(
                            emailBuyer: emailBuyer,
                            indexFish: index,
                            price: price,
                            fishingUsecase: sl.get<FishingUsecase>()));
                    Navigator.of(context).pop();
                  },
                  child: const Text('accept_offer',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.blue,
                        fontFamily: 'skullsandcrossbones',
                      )).tr(),
                ),
              ],
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
                      "highest_bid".tr() + price.toString(),
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
  } else {
    //submitting bids on someone else's fish
    final TextEditingController? offerController = TextEditingController();
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('cancel',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.blue,
                        fontFamily: 'skullsandcrossbones',
                      )).tr(),
                ),
                TextButton(
                  onPressed: () {
                    final FirebaseAuth auth = FirebaseAuth.instance;

                    String emailBuyer = auth.currentUser!.email ?? "";
                    String price = offerController!.text;
                    if (price.isEmpty) return;
                    String emailSeller = email;
                    int indexFish = index;
                    BlocProvider.of<FishingBloc>(context).add(
                        SendPriceOfferCollectionFishEvent(
                            emailBuyer: emailBuyer,
                            price: price,
                            emailSeller: emailSeller,
                            indexFish: indexFish,
                            fishingUsecase: sl.get<FishingUsecase>()));
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.blue,
                        fontFamily: 'skullsandcrossbones',
                      )).tr(),
                ),
              ],
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
                    width: 120,
                    height: 120,
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'skullsandcrossbones',
                    fontSize: 24.0,
                    color: Colors.redAccent,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 200,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Offer',
                        ),
                        keyboardType: TextInputType.number,
                        controller: offerController,
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
