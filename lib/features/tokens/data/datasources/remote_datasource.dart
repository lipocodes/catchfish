import 'package:catchfish/features/tokens/data/models/products_model.dart';
import 'package:catchfish/features/tokens/domain/entities/products_entity.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class RemoteDatasource {
  final _productIds = {'product1', 'product2', 'product3'};
  //products offerd to purchase
  List<ProductDetails> _products = [];
  final InAppPurchase _connection = InAppPurchase.instance;
  final List<String> _listProd = [];
  buyTokens() async {}
  Future<ProductsEntity> getProducts() async {
    try {
      ProductDetailsResponse productDetailResponse =
          await _connection.queryProductDetails(_productIds);
      _products = productDetailResponse.productDetails;
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

      ProductsModel productsModel = ProductsModel(listProducts: _listProd);
      return productsModel;
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeee=" + e.toString());
      ProductsModel productsModel = ProductsModel(listProducts: _listProd);
      return productsModel;
    }
  }
}
