import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tokens_event.dart';
part 'tokens_state.dart';

class TokensBloc extends Bloc<TokensEvent, TokensState> {
  TokensBloc() : super(TokensInitial()) {
    on<TokensEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
