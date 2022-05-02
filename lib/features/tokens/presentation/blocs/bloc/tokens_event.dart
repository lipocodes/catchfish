part of 'tokens_bloc.dart';

abstract class TokensEvent extends Equatable {
  const TokensEvent();

  @override
  List<Object> get props => [];
}

class BuyTokensEvent implements TokensEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
