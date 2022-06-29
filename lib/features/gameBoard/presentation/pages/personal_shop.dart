import 'dart:async';

import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/personalShop/shop_items.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalShop extends StatefulWidget {
  const PersonalShop({Key? key}) : super(key: key);

  @override
  State<PersonalShop> createState() => _PersonalShopState();
}

class _PersonalShopState extends State<PersonalShop> {
  bool _showedWarningYet = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fishingUsecase = sl.get<FishingUsecase>();
    BlocProvider.of<FishingBloc>(context)
        .add(LoadingPersonalShopEvent(fishingUsecase: fishingUsecase));
  }

  @override
  Widget build(BuildContext context) {
    showLoginWarning(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            //extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: shopItems(context)));
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
                          Navigator.pop(context);
                        })
                  ],
                ));
      });
    }
  }
}
