import 'dart:async';

import 'package:catchfish/features/tokens/data/models/products_model.dart';
import 'package:catchfish/features/tokens/data/models/tokens_model.dart';
import 'package:catchfish/features/tokens/domain/entities/products_entity.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class RemoteDatasource {
  final _productIds = {'product1', 'product2', 'product3'};
  //products offerd to purchase
  List<ProductDetails> _products = [];
  final InAppPurchase _connection = InAppPurchase.instance;
  final List<String> _listProd = [];
  //products that have been purchased by this user
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  Future<ProductsEntity> getProducts() async {
    try {
      bool isAvailable = await _connection.isAvailable();
      if (isAvailable) {
        ProductDetailsResponse productDetailResponse =
            await _connection.queryProductDetails(_productIds);
        _products = productDetailResponse.productDetails;
        print("Number of products for sale=" + _products.length.toString());
        for (int a = 0; a < _products.length; a++) {
          if (productDetailResponse.error == null) {
            String prod = _products[a].id +
                "^^^" +
                _products[a].title +
                "^^^" +
                _products[a].description +
                "^^^" +
                _products[a].price;
            _listProd.add(prod);
          }
        }
      }
      ProductsModel productsModel = ProductsModel(listProducts: _listProd);
      return productsModel;
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeee=" + e.toString());
      ProductsModel productsModel = ProductsModel(listProducts: _listProd);
      return productsModel;
    }
  }

  //////////////////////////////////////////////////////////////////////////////////
  listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("Purchase pending!!!!!!!!!!!!!!!");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print("PurchaseStatus.error!!!!!!!!!");
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          print("Purchase successful!!!!!!!!!");
          _connection.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<TokensModel> buyTokens(String prodID) async {
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

    TokensModel tokensModel = TokensModel(result: "success");
    return tokensModel;
  }

  ////////////////////////////////////////////////////////////////////////////////
}
