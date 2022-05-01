import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:io';

class BuyToken extends StatefulWidget {
  const BuyToken({Key? key}) : super(key: key);

  @override
  _BuyTokenState createState() => _BuyTokenState();
}

class _BuyTokenState extends State<BuyToken> {
  final _productIds = {
    'token1',
  };
  final InAppPurchase _connection = InAppPurchase.instance;
  //products that have been purchased by this user
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  //products offerd to purchase
  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();

    //get notified by async changes on purchases list
    _connection.purchaseStream.listen((purchaseDetailsList) {
      //_listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    //We need to see what's in the shop..
    initStoreInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initStoreInfo() async {
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_productIds);
    if (productDetailResponse.error == null) {
      setState(() {
        _products = productDetailResponse.productDetails;
        print("cccccccccccccccc=" + _products[0].title.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
