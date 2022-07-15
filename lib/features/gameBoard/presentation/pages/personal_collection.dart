import 'dart:async';

import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/personalShop/app_bar.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/personalShop/shop_items.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalCollection extends StatefulWidget {
  const PersonalCollection({Key? key}) : super(key: key);

  @override
  State<PersonalCollection> createState() => _PersonalCollectionState();
}

class _PersonalCollectionState extends State<PersonalCollection> {
  bool _showedWarningYet = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fishingUsecase = sl.get<FishingUsecase>();
    BlocProvider.of<FishingBloc>(context)
        .add(LoadingPersonalShopEvent(fishingUsecase: fishingUsecase));
  }

  performBack() {
    BlocProvider.of<LobbyBloc>(context).add(const ReturningLobbyEvent());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    showLoginWarning(context);
    return SafeArea(
        child: WillPopScope(
      onWillPop: () => performBack(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          //extendBodyBehindAppBar: true,
          appBar: appBar(context),
          body: shopItems(context)),
    ));
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
