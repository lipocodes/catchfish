import 'package:catchfish/features/tokens/data/datasources/remote_datasource.dart';
import 'package:catchfish/features/tokens/data/models/products_model.dart';
import 'package:catchfish/features/tokens/data/models/tokens_model.dart';
import 'package:catchfish/features/tokens/domain/entities/products_entity.dart';
import 'package:catchfish/features/tokens/domain/entities/tokens_entity.dart';
import 'package:catchfish/features/tokens/domain/repositories/tokens_repository.dart';

class TokensRepositoryImpl implements TokensRepository {
  @override
  Future<TokensEntity> buyTokens(String prodID) async {
    RemoteDatasource remoteDatasource = RemoteDatasource();
    TokensModel tokensModel = remoteDatasource.buyTokens(prodID);
    TokensEntity tokensEntity = tokensModel;
    return tokensEntity;
  }

  @override
  Future<ProductsEntity> getProducts() async {
    RemoteDatasource remoteDatasource = RemoteDatasource();
    ProductsEntity productsModel = await remoteDatasource.getProducts();
    ProductsEntity productsEntity = productsModel;
    return productsEntity;
  }
}
