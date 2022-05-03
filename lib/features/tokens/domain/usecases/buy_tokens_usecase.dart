import 'dart:async';

import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/tokens/domain/entities/tokens_entity.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class BuyTokensUsecase {
  final InAppPurchase _connection = InAppPurchase.instance;
  //products that have been purchased by this user
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  //products offerd to purchase
  List<ProductDetails> _products = [];
  late PlaySound playSound;

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

  Future<TokensEntity> buyTokens(String prodID) async {
    //get notified by async changes on purchases list
    _connection.purchaseStream.listen((purchaseDetailsList) {
      listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    try {
      ProductDetailsResponse productDetailResponse =
          await _connection.queryProductDetails({prodID});
      if (productDetailResponse.error == null) {
        _products = productDetailResponse.productDetails;
        final PurchaseParam purchaseParam =
            PurchaseParam(productDetails: _products[0]);
        await _connection.buyConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeee buyConsumables=" + e.toString());
    }

    TokensEntity tokensEntity = TokensEntity(result: "success");
    return tokensEntity;
  }
}
