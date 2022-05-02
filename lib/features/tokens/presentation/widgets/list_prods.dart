import 'package:catchfish/features/tokens/presentation/widgets/prod.dart';
import 'package:flutter/material.dart';

Widget listProds(state, BuildContext context) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: SafeArea(
      child: Scaffold(
        body: Container(
            height: 1000,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  //tenor.com
                  'assets/images/tokens/skeleton.gif',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                prod(state, 0, context),
                prod(state, 0, context),
                prod(state, 0, context),
                prod(state, 0, context)
              ],
            )),
      ),
    ),
  );
}
