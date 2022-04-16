import 'package:catchfish/features/settings/presentation/widgets/button_back.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget appBar(BuildContext context) {
  //custom BACK operation
  performBack(BuildContext context) async {
    Navigator.pop(context, true);
    Navigator.pop(context, true);
    Navigator.pushNamed(context, '/');
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
    actions: [
      Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (auth.currentUser != null) {
                await FirebaseAuth.instance.signOut();
                performBack(context);
              } else {
                await Navigator.pushNamed(context, '/login');
                performBack(context);
              }
            },
            child: Text(auth.currentUser == null ? "Login".tr() : "Logout".tr(),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 24.0,
                  fontFamily: 'skullsandcrossbones',
                )),
          ),
          const SizedBox(
            width: 100,
          ),
          buttonBack(context),
        ],
      ),
    ],
  );
}
