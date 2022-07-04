import 'package:catchfish/features/tokens/presentation/widgets/button_back.dart';
import 'package:catchfish/features/tokens/presentation/widgets/prod.dart';
import 'package:flutter/material.dart';

Widget listProds(state, BuildContext context) {
  //custom BACK operation
  Future<bool> performBack() async {
    Navigator.pop(context, true);
    Navigator.pop(context, true);
    Navigator.pushNamed(context, '/lobby');
    return true;
  }

  return Directionality(
    textDirection: TextDirection.ltr,
    child: SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return performBack();
        },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      buttonBack(performBack),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  prod(state, 0, context),
                  prod(state, 1, context),
                  prod(state, 2, context),
                ],
              )),
        ),
      ),
    ),
  );
}
