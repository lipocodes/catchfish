import 'dart:async';

import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/tokens/presentation/blocs/bloc/tokens_bloc.dart';
import 'package:catchfish/features/tokens/presentation/widgets/list_prods.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyToken extends StatefulWidget {
  const BuyToken({Key? key}) : super(key: key);

  @override
  _BuyTokenState createState() => _BuyTokenState();
}

class _BuyTokenState extends State<BuyToken> {
  bool _showedWarningYet = false;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TokensBloc>(context).add(GetOfferedProductsEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  performBack() {
    BlocProvider.of<LobbyBloc>(context).add(const ReturningLobbyEvent());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    showLoginWarning(context);
    return BlocBuilder<TokensBloc, TokensState>(
      builder: (context, state) {
        if (state is GetOfferedProductsState) {
          return listProds(state, context);
        } else if (state is BuyTokensState) {
          return listProds(state, context);
        } else {
          return Container();
        }
      },
    );
  }

  showLoginWarning(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null && _showedWarningYet == false) {
      _showedWarningYet = true;
      Timer(const Duration(seconds: 1), () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text('not_logged_in').tr(),
                  content: const Text('text_not_logged_in').tr(),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ));
      });
    }
  }
}
