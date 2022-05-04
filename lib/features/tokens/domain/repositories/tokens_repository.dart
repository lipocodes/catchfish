import 'package:catchfish/features/tokens/domain/entities/products_entity.dart';
import 'package:catchfish/features/tokens/domain/entities/tokens_entity.dart';

abstract class TokensRepository {
  Future<TokensEntity> buyTokens(String prodID);
  Future<ProductsEntity> getProducts();
}
