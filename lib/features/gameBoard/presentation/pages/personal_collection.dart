import 'dart:async';

import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/personalShop/app_bar.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/personalShop/personal_collection_items.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalCollection extends StatefulWidget {
  const PersonalCollection({Key? key}) : super(key: key);

  @override
  State<PersonalCollection> createState() => _PersonalCollectionState();
}

class _PersonalCollectionState extends State<PersonalCollection> {
  TextEditingController searchPlayerController = TextEditingController();
  bool _showedWarningYet = false;
  String show = "show";
  bool showPersonalCollection = true;
  @override
  void initState() {
    super.initState();
    retreivePrefs();
    final fishingUsecase = sl.get<FishingUsecase>();
    BlocProvider.of<FishingBloc>(context).add(LoadingPersonalCollectionEvent(
        fishingUsecase: fishingUsecase, email: ""));
  }

  retreivePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    showPersonalCollection = prefs.getBool(
          "showPersonalCollection",
        ) ??
        true;
    showPersonalCollection == true ? show = "Show" : show = "hide";
    setState(() {});
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
                  showHideCollection(),
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

  showHideCollection() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Text(
            "show_collection_other_players".tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontFamily: 'skullsandcrossbones',
            ),
          ),
          ListTile(
            title: const Text(
              "Show",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: 'skullsandcrossbones',
              ),
            ),
            leading: Radio(
                toggleable: true,
                activeColor: Colors.white,
                fillColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue),
                value: "show".tr(),
                groupValue: show,
                onChanged: (value) {
                  setState(() {
                    show = value.toString();
                    final fishingUsecase = sl.get<FishingUsecase>();
                    BlocProvider.of<FishingBloc>(context).add(
                        ChangeShowCollectionEvent(
                            show: show, fishingUsecase: fishingUsecase));
                  });
                }),
          ),
        ],
      ),
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
          if (text.isEmpty) {
            final fishingUsecase = sl.get<FishingUsecase>();
            BlocProvider.of<FishingBloc>(context).add(
                LoadingPersonalCollectionEvent(
                    fishingUsecase: fishingUsecase, email: ""));
          } else {
            final fishingUsecase = sl.get<FishingUsecase>();
            BlocProvider.of<FishingBloc>(context)
                .add(SearchOtherPlayersEvent(name: text));
          }
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
                  String email = list[0];
                  return ListTile(
                      onTap: () {
                        final fishingUsecase = sl.get<FishingUsecase>();
                        BlocProvider.of<FishingBloc>(context).add(
                            LoadingPersonalCollectionEvent(
                                fishingUsecase: fishingUsecase, email: email));
                      },
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
