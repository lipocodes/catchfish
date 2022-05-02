import 'package:catchfish/features/tokens/data/models/tokens_model.dart';
import 'package:catchfish/features/tokens/domain/entities/tokens_entity.dart';
import 'package:catchfish/features/tokens/domain/repositories/tokens_repository.dart';

class TokensRepositoryImpl implements TokensRepository {
  @override
  Future<TokensEntity> buyTokens() async {
    TokensModel tokensModel = TokensModel(result: "success");
    TokensEntity tokensEntity = tokensModel;
    return tokensEntity;
  }
}
