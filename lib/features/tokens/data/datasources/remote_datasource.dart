import 'package:catchfish/features/tokens/data/models/products_model.dart';
import 'package:catchfish/features/tokens/domain/entities/products_entity.dart';

class RemoteDatasource {
  buyTokens() async {}
  Future<ProductsEntity> getProducts() async {
    ProductsModel productsModel =
        ProductsModel(listProducts: ["1003^^^Money^^^Money tokens^^^0.20"]);
    return productsModel;
  }
}
