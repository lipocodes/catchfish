import 'package:catchfish/features/tokens/data/models/products_model.dart';
import 'package:catchfish/features/tokens/domain/entities/products_entity.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class RemoteDatasource {
  final _productIds = {
    'product1',
    'product2',
  };
  //products offerd to purchase
  List<ProductDetails> _products = [];
  final InAppPurchase _connection = InAppPurchase.instance;
  List<String> _listProd = [];
  buyTokens() async {}
  Future<ProductsEntity> getProducts() async {
    for (int a = 0; a < _productIds.length; a++) {
      try {
        ProductDetailsResponse productDetailResponse =
            await _connection.queryProductDetails(_productIds);
        if (productDetailResponse.error == null) {
          //products in the store
          _products = productDetailResponse.productDetails;
          String prod = _products[a].id +
              "^^^" +
              _products[a].title +
              "^^^" +
              _products[a].description +
              "^^^" +
              _products[a].price;
          _listProd.add(prod);
        }
      } catch (e) {}
    }

    ProductsModel productsModel = ProductsModel(listProducts: _listProd);
    return productsModel;
  }
}
