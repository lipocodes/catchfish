import 'dart:async';

import 'package:catchfish/features/gameBoard/domain/usecases/fishing/selectGroup_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/selectGroupBloc/selectgroup_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/selectGroup/button_start_game.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/selectGroup/selector_group_type.dart';
import 'package:catchfish/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectGroup extends StatefulWidget {
  const SelectGroup({Key? key}) : super(key: key);

  @override
  State<SelectGroup> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SelectGroup> {
  bool _showedWarningYet = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    setPrefs();
    BlocProvider.of<SelectgroupBloc>(context).add(
        EnteringScreenEvent(selectGroupUsecase: sl.get<SelectGroupUsecase>()));
  }

  setPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("selectedGroupType", 0);
    await prefs.setBool('amIGroupLeader', false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: BlocBuilder<SelectgroupBloc, SelectgroupState>(
              builder: (context, state) {
                if (state is NotAllowedStartGame) {
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("name_exists".tr()),
                        content: Text("need_another_name".tr()),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Container(
                              color: Colors.blue,
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                "ok".tr(),
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });

                  return gui(context);
                } else {
                  return gui(context);
                }
              },
            )),
      ),
    );
  }

  showLoginWarning(BuildContext context) async {
    if (_auth.currentUser == null && _showedWarningYet == false) {
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

  Widget gui(BuildContext context) {
    //custom BACK operation
    performBack() async {
      Navigator.pop(context, true);
    }

    showLoginWarning(context);
    String playerName = _auth.currentUser?.displayName ?? "";
    BlocProvider.of<SelectgroupBloc>(context).add(YourNameChangedEvent(
        yourName: yourNameController.text,
        selectedGroup: groupNameController.text));

    return Container(
      height: 1000,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            //tenor.com
            'assets/images/gameBoard/palm.gif',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonStartGame(context),
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 28.0,
                ),
                onPressed: () {
                  performBack();
                },
              ),
            ],
          ),
          const SizedBox(
            height: 50.0,
          ),
          selectorGroupType(context, playerName),
        ],
      ),
    );
  }
}
