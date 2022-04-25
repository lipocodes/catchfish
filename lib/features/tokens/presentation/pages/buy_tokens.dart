/*import 'package:catchfish/features/login/presentation/blocs/provider/google_sign_in.dart';
import 'package:catchfish/features/tokens/presentation/blocs/provider/tokens_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyTokens extends StatefulWidget {
  const BuyTokens({Key? key}) : super(key: key);

  @override
  State<BuyTokens> createState() => _BuyTokensState();
}

class _BuyTokensState extends State<BuyTokens> {
  @override
  void initState() {
    final provider = Provider.of<TokensProvider>(context, listen: false);
    provider.initialize();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    final provider = Provider.of<TokensProvider>(context, listen: false);
    provider.subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:io';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

const String testID = 'book_test';

class Purchase extends StatefulWidget {
  const Purchase({Key? key}) : super(key: key);

  @override
  _PurchaseState createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  // Instantiates inAppPurchase
  final InAppPurchase _iap = InAppPurchase.instance;

  // checks if the API is available on this device
  bool _isAvailable = false;

  // keeps a list of products queried from Playstore or app store
  List<ProductDetails> _products = [];

  // List of users past purchases
  List<PurchaseDetails> _purchases = [];

  // subscription that listens to a stream of updates to purchase details
  late StreamSubscription _subscription;

  // used to represents consumable credits the user can buy
  int _coins = 0;

  Future<void> _initialize() async {
    // Check availability of InApp Purchases
    _isAvailable = await _iap.isAvailable();

    // perform our async calls only when in-app purchase is available
    if (_isAvailable) {
      await _getUserProducts();
      await _getPastPurchases();
      _verifyPurchases();

      // listen to new purchases and rebuild the widget whenever
      // there is a new purchase after adding the new purchase to our
      // purchase list

      _subscription = _iap.purchaseStream.listen((data) => setState(() {
            _purchases.addAll(data);
            _verifyPurchases();
          }));
    }
  }

  // Method to retrieve product list
  Future<void> _getUserProducts() async {
    Set<String> ids = {testID};
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
    });
  }

  // Method to retrieve users past purchase
  Future<void> _getPastPurchases() async {
    /*QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _iap.completePurchase(purchase);
      }
    }
    setState(() {
      _purchases = response.pastPurchases;
    });
  }*/
  }
  // checks if a user has purchased a certain product
  PurchaseDetails _hasUserPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID);
  }

  // Method to check if the product has been purchased already or not.
  void _verifyPurchases() {
    PurchaseDetails purchase = _hasUserPurchased(testID);
    if (purchase.status == PurchaseStatus.purchased) {
      _coins = 10;
    }
  }
}
