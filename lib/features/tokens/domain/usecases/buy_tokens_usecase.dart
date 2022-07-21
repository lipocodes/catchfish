import 'dart:async';

import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/tokens/data/repositories/tokens_repository_impl.dart';
import 'package:catchfish/features/tokens/domain/entities/tokens_entity.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class BuyTokensUsecase {
  Future<TokensEntity> buyTokens(String prodID) async {
    TokensRepositoryImpl tokensRepositoryImpl = TokensRepositoryImpl();
    TokensEntity tokensEntity = await tokensRepositoryImpl.buyTokens(prodID);
    return tokensEntity;
  }
}
