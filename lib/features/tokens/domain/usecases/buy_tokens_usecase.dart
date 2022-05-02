import 'package:catchfish/features/tokens/domain/entities/tokens_entity.dart';

class BuyTokensUsecase {
  Future<TokensEntity> buyTokens() async {
    TokensEntity tokensEntity = TokensEntity(result: "success");
    return tokensEntity;
  }
}
