import 'package:catchfish/features/login/domain/entities/user_entity.dart';
import 'package:catchfish/features/login/domain/usecases/saveUserDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      var res = await FirebaseAuth.instance.signInWithCredential(credential);
      if (res.user != null) {
        String? displayName = res.user!.displayName;
        String? email = res.user!.email;
        String? photoURL = res.user!.photoURL;
        String? phoneNumber = res.user!.phoneNumber;
        UserEntity userEntity = UserEntity(
            displayName: displayName ?? "",
            email: email ?? "",
            photoURL: photoURL ?? "",
            phoneNumber: phoneNumber ?? "");
        SaveUserDetails saveUserDetails = SaveUserDetails();
        saveUserDetails.call(userEntity);
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeeee googleLogin()=" + e.toString());
    }
    notifyListeners();
  }

  Future googleLogout() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {
      print("eeeeeeeeeeeeee=" + e.toString());
    }
  }
}
