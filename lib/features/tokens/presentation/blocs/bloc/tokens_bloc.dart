import 'package:bloc/bloc.dart';
import 'package:catchfish/features/tokens/domain/entities/products_entity.dart';
import 'package:catchfish/features/tokens/domain/entities/tokens_entity.dart';
import 'package:catchfish/features/tokens/domain/usecases/buy_tokens_usecase.dart';
import 'package:catchfish/features/tokens/domain/usecases/get_offered_products_usecase.dart';
import 'package:equatable/equatable.dart';

part 'tokens_event.dart';
part 'tokens_state.dart';

class TokensBloc extends Bloc<TokensEvent, TokensState> {
  TokensBloc() : super(TokensInitial()) {
    on<TokensEvent>((event, emit) async {
      if (event is GetOfferedProductsEvent) {
        GetOfferedProductsUsecase getOfferedProductsUsecase =
            GetOfferedProductsUsecase();
        ProductsEntity productsEntity =
            await getOfferedProductsUsecase.getProdcuts();
        if (productsEntity.listProducts.isEmpty) {
          Future.delayed(const Duration(milliseconds: 1 * 1000), () async {
            productsEntity = await getOfferedProductsUsecase.getProdcuts();
            emit(GetOfferedProductsState(productsEntity: productsEntity));
          });
        } else {
          emit(GetOfferedProductsState(productsEntity: productsEntity));
        }
      } else if (event is BuyTokensEvent) {
        BuyTokensUsecase buyTokensUsecase = BuyTokensUsecase();
        TokensEntity tokensEntity =
            await buyTokensUsecase.buyTokens(event.prodID);
        emit(BuyTokensState(tokensEntity: tokensEntity));
      }
    });
  }
}
