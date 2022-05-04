import 'package:catchfish/features/tokens/presentation/blocs/bloc/tokens_bloc.dart';
import 'package:catchfish/features/tokens/presentation/widgets/list_prods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyToken extends StatefulWidget {
  const BuyToken({Key? key}) : super(key: key);

  @override
  _BuyTokenState createState() => _BuyTokenState();
}

class _BuyTokenState extends State<BuyToken> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TokensBloc>(context).add(GetOfferedProductsEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TokensBloc, TokensState>(
      builder: (context, state) {
        if (state is GetOfferedProductsState) {
          return listProds(state, context);
        } else if (state is BuyTokensState) {
          return listProds(state, context);
        } else if (state is UpdatePrizeListState) {
          print("aaaaaaaaaaaaaaaaaaaaa=" + state.inventoryMoney.toString());
          print("bbbbbbbbbbbbbbbbbbb=" + state.inventoryBaits.toString());
          print("ccccccccccccccccc=" + state.inventoryXP.toString());
          return listProds(state, context);
        } else {
          return Container();
        }
      },
    );
  }
}
