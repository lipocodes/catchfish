import 'package:catchfish/features/tokens/domain/entities/tokens_entity.dart';

abstract class TokensRepository {
  Future<TokensEntity> buyTokens();
}
