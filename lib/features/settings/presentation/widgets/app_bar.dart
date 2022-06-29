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
  );
}
