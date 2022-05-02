import 'package:bloc/bloc.dart';
import 'package:catchfish/features/tokens/domain/entities/tokens_entity.dart';
import 'package:catchfish/features/tokens/domain/usecases/buy_tokens_usecase.dart';
import 'package:equatable/equatable.dart';

part 'tokens_event.dart';
part 'tokens_state.dart';

class TokensBloc extends Bloc<TokensEvent, TokensState> {
  TokensBloc() : super(TokensInitial()) {
    on<TokensEvent>((event, emit) async {
      BuyTokensUsecase buyTokensUsecase = BuyTokensUsecase();
      TokensEntity tokensEntity = await buyTokensUsecase.buyTokens();
      emit(BuyTokensState(tokensEntity: tokensEntity));
    });
  }
}
