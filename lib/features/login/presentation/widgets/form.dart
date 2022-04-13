import 'package:catchfish/features/login/presentation/blocs/provider/apple_sign_in.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/facebook_sign_in.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

Widget form(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      //const Spacer(),
      SizedBox(
        child: Image.asset(
          "assets/images/login/steering.png",
        ),
      ),
      //const Spacer(),
      Align(
          alignment: Alignment.center,
          child: Text(
            "need_login".tr(),
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )),
      const SizedBox(height: 8.00),
      Align(
          alignment: Alignment.center,
          child: Text(
            "login_your_account".tr(),
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          )),
      const Spacer(),
      ElevatedButton.icon(
        label: const Text("Sign Up with Google"),
        onPressed: () {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.googleLogin();
        },
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            primary: Colors.blue,
            onPrimary: Colors.white,
            minimumSize: const Size(double.infinity, 50)),
        icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
      ),
      const SizedBox(
        height: 10.0,
      ),
      ElevatedButton.icon(
        label: const Text("Sign Up with Facebook"),
        onPressed: () {
          final provider =
              Provider.of<FacebookSignInProvider>(context, listen: false);
          provider.facebookLogin();
        },
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            primary: Colors.white,
            onPrimary: Colors.black,
            minimumSize: const Size(double.infinity, 50)),
        icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
      ),
      if (Platform.isIOS) ...[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            label: const Text("Sign Up with Apple"),
            onPressed: () {
              final provider =
                  Provider.of<AppleSignInProvider>(context, listen: false);
              provider.appleLogin();
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                primary: Colors.yellow,
                onPrimary: Colors.red,
                minimumSize: const Size(double.infinity, 50)),
            icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.blue),
          ),
        ),
      ],
    ],
  );
}
