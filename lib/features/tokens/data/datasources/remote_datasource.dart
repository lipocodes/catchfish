import 'dart:async';

import 'package:catchfish/features/tokens/data/models/products_model.dart';
import 'package:catchfish/features/tokens/data/models/tokens_model.dart';
import 'package:catchfish/features/tokens/domain/entities/products_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteDatasource {
  final _productIds = {'product1', 'product2', 'product3'};
  //products offerd to purchase
  List<ProductDetails> _products = [];
  final InAppPurchase _connection = InAppPurchase.instance;
  final List<String> _listProd = [];
  //products that have been purchased by this user
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late SharedPreferences _prefs;
  final FirebaseAuth auth = FirebaseAuth.instance;

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
  updatePrefsAndDB() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      String prodID = await _prefs.getString(
            "prodID",
          ) ??
          "";

      int inventoryMoney = _prefs.getInt(
            "inventoryMoney",
          ) ??
          0;
      int inventoryBaits = _prefs.getInt(
            "inventoryBaits",
          ) ??
          0;
      int inventoryXP = _prefs.getInt(
            "inventoryXP",
          ) ??
          0;
      if (prodID.contains("Money")) {
        inventoryMoney = inventoryMoney + 10;
      } else if (prodID.contains("Baits")) {
        inventoryBaits = inventoryBaits + 10;
      } else if (prodID.contains("XP")) {
        inventoryXP = inventoryXP + 10;
      }

      _prefs.setInt("inventoryMoney", inventoryMoney);
      _prefs.setInt("inventoryBaits", inventoryBaits);
      _prefs.setInt("inventoryXP", inventoryXP);

      if (auth.currentUser == null) {
        ////////////////////emit
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }

  listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("Purchase pending!!!!!!!!!!!!!!!");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print("PurchaseStatus.error!!!!!!!!!");
          /////////////////// emit
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          print("Purchase successful!!!!!!!!!");
          _connection.completePurchase(purchaseDetails);
          await updatePrefsAndDB();
        }
      }
    });
  }

  Future<TokensModel> buyTokens(String prodID) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("prodID", prodID);
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
