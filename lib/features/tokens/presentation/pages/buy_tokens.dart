import 'dart:async';
import 'package:catchfish/features/tokens/presentation/blocs/bloc/tokens_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    BlocProvider.of<TokensBloc>(context).add(BuyTokensEvent());

    //get notified by async changes on purchases list
    _connection.purchaseStream.listen((purchaseDetailsList) {
      listenToPurchaseUpdated(purchaseDetailsList);
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
        //products in the store
        _products = productDetailResponse.productDetails;
        print("ppppppppppppppppppp=" + _products.toString());
        buyProduct();
      });
    }
  }

  listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("Purchase pending!!!!!!!!!!!!!!!");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print("PurchaseStatus.error!!!!!!!!!");
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          print("Purchase successful!!!!!!!!!");
          String? purchaseID = purchaseDetails.purchaseID;
          String? productID = purchaseDetails.productID;
          String? transactionDate = purchaseDetails.transactionDate;
          print("aaaaaaaaaaaaaaaaa=" + purchaseID.toString());
          print("bbbbbbbbbbbbbbbb=" + productID.toString());
          print("cccccccccccccccc=" + transactionDate.toString());
        }
      }
    });
  }

  buyProduct() {
    try {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: _products[0]);
      _connection.buyConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TokensBloc, TokensState>(
      listener: (context, state) {
        if (state is BuyTokensState) {
          print("ddddddddddddddd=" + state.tokensEntity.result.toString());
        }
      },
      child: Scaffold(
        body: Container(),
      ),
    );
  }
}
