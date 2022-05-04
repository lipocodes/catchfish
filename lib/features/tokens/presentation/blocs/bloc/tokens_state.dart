part of 'tokens_bloc.dart';

abstract class TokensState extends Equatable {
  const TokensState();

  @override
  List<Object> get props => [];
}

class TokensInitial extends TokensState {}

class BuyTokensState extends TokensState {
  final TokensEntity tokensEntity;
  const BuyTokensState({required this.tokensEntity});
}

class GetOfferedProductsState extends TokensState {
  final ProductsEntity productsEntity;
  const GetOfferedProductsState({required this.productsEntity});
}

class UpdatePrizeListState extends TokensState {
  final int inventoryMoney;
  final int inventoryBaits;
  final int inventoryXP;
  const UpdatePrizeListState(
      {required this.inventoryMoney,
      required this.inventoryBaits,
      required this.inventoryXP});
}
