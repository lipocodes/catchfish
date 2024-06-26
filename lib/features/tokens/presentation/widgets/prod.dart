import 'dart:async';

import 'package:catchfish/features/tokens/presentation/blocs/bloc/tokens_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget prod(state, int prodNum, BuildContext context) {
  List<String> prod = [];
  try {
    String temp = state.productsEntity.listProducts[prodNum];

    prod = temp.split("^^^");
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prod[1].replaceAll("(Catch Fish)", ""),
            style: const TextStyle(
              fontSize: 28.0,
              color: Colors.red,
              fontFamily: 'skullsandcrossbones',
            ),
          ),
          Text(
            prod[2],
            style: const TextStyle(
              fontSize: 28.0,
              color: Colors.red,
              fontFamily: 'skullsandcrossbones',
            ),
          ),
          ElevatedButton(
            child: Text(
              prod[3],
              style: const TextStyle(
                fontSize: 28.0,
                color: Colors.red,
                fontFamily: 'skullsandcrossbones',
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () {
              final FirebaseAuth auth = FirebaseAuth.instance;
              if (auth.currentUser == null) {
                Timer(const Duration(seconds: 1), () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text('not_logged_in').tr(),
                            content: const Text('need_log_in').tr(),
                            actions: <Widget>[
                              IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, '/lobby');
                                  })
                            ],
                          ));
                });
              } else {
                BlocProvider.of<TokensBloc>(context)
                    .add(BuyTokensEvent(prodID: prod[0]));
              }
            },
          ),
        ],
      ),
    );
  } catch (e) {
    return Container();
  }
}
