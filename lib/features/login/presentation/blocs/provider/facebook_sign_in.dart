import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/cupertino.dart';

class FacebookSignInProvider extends ChangeNotifier {
  Future facebookLogin() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await FirebaseAuth.instance.signInWithCredential(facebookCredential);
      } else if (result.status == LoginStatus.operationInProgress) {
        print("bbbbbbbbbbbbbbbb");
      } else {
        print("cccccccccccccccc");
      }
    } on FirebaseAuthException catch (e) {
      print("eeeeeeeeeeeeeeeee=" + e.toString());
      throw e;
    }

    notifyListeners();
  }

  facebookLogout() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }
}
