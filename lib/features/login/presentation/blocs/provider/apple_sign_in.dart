import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/cupertino.dart';

class AppleSignInProvider extends ChangeNotifier {
  Future appleLogin() async {
    try {
      print("xxxxxxxxxxxxxxxxxx");
    } on FirebaseAuthException catch (e) {
      print("eeeeeeeeeeeeeeeee=" + e.toString());
      throw e;
    }

    notifyListeners();
  }

  AppleLogout() async {
    try {
      //await FacebookAuth.instance.logOut();
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }
}
