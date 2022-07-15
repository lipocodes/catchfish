import 'dart:async';

import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/personalShop/app_bar.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/personalShop/personal_collection_items.dart';
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
  TextEditingController searchPlayerController = TextEditingController();
  bool _showedWarningYet = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fishingUsecase = sl.get<FishingUsecase>();
    BlocProvider.of<FishingBloc>(context)
        .add(LoadingPersonalCollectionEvent(fishingUsecase: fishingUsecase));
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
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Scaffold(
            backgroundColor: Colors.transparent,
            //extendBodyBehindAppBar: true,
            appBar: appBar(context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  searchOtherPlayers(),
                  listRelevantPlayers(),
                  const SizedBox(
                    height: 20.0,
                  ),
                  personalCollectionItems(context),
                ],
              ),
            )),
      ),
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

  Widget searchOtherPlayers() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextField(
        controller: searchPlayerController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'skullsandcrossbones',
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          // labelText: ' Find Other Player ',
          hintText: ' Find Other Players ',
          hintStyle: TextStyle(
              fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w100),
          enabledBorder: InputBorder.none,
        ),
        onChanged: (text) {
          BlocProvider.of<FishingBloc>(context)
              .add(SearchOtherPlayersEvent(name: text));
        },
      ),
    );
  }

  Widget listRelevantPlayers() {
    return BlocBuilder<FishingBloc, FishingState>(
      builder: (context, state) {
        if (state is SearchOtherPlayersState) {
          List<String> relevantPlayers = state.relevantPlayers;
          return SizedBox(
            height: 200.0,
            child: ListView.builder(
                itemCount: state.relevantPlayers.length,
                itemBuilder: (BuildContext context, int index) {
                  String temp = relevantPlayers[index];
                  List<String> list = temp.split("^^^");
                  String name = list[1];
                  return ListTile(
                      onTap: () {},
                      title: Center(
                        child: Text(
                          name,
                          style: const TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'skullsandcrossbones',
                              backgroundColor: Colors.blueAccent),
                        ),
                      ));
                }),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
