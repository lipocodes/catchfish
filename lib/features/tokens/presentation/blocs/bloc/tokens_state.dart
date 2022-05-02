part of 'tokens_bloc.dart';

abstract class TokensState extends Equatable {
  const TokensState();

  @override
  List<Object> get props => [];
}

class TokensInitial extends TokensState {}

class BuyTokensState extends TokensState {
  TokensEntity tokensEntity = TokensEntity(result: "success");
  BuyTokensState({required this.tokensEntity});
}
