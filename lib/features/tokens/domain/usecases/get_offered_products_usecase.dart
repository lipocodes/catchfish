import 'package:catchfish/features/tokens/data/repositories/tokens_repository_impl.dart';
import 'package:catchfish/features/tokens/domain/entities/products_entity.dart';

class GetOfferedProductsUsecase {
  Future<ProductsEntity> getProdcuts() async {
    TokensRepositoryImpl tokensRepositoryImpl = TokensRepositoryImpl();
    ProductsEntity productsEntity = await tokensRepositoryImpl.getProducts();
    return productsEntity;
  }
}
