part of 'tokens_bloc.dart';

abstract class TokensEvent extends Equatable {
  const TokensEvent();

  @override
  List<Object> get props => [];
}

class GetOfferedProductsEvent implements TokensEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class BuyTokensEvent implements TokensEvent {
  late final String prodID;
  BuyTokensEvent({required this.prodID});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}

class UpdatePrizeListEvent implements TokensEvent {
  late final int inventoryMoney;
  late final int inventoryBaits;
  late final int inventoryXP;
  UpdatePrizeListEvent(
      {required this.inventoryMoney,
      required this.inventoryBaits,
      required this.inventoryXP});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
