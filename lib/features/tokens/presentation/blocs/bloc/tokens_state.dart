part of 'tokens_bloc.dart';

abstract class TokensState extends Equatable {
  const TokensState();
  
  @override
  List<Object> get props => [];
}

class TokensInitial extends TokensState {}
