import 'package:catchfish/features/login/presentation/blocs/provider/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

Widget form(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      //const Spacer(),
      Image.asset(
        "assets/images/introduction/boat_steering.png",
      ),
      const Spacer(),
      Align(
          alignment: Alignment.centerLeft,
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
          alignment: Alignment.centerLeft,
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
            primary: Colors.white,
            onPrimary: Colors.black,
            minimumSize: const Size(double.infinity, 50)),
        icon: const FaIcon(FontAwesomeIcons.google, color: Colors.blue),
      ),
      const SizedBox(
        height: 40.0,
      ),
      RichText(
        text: const TextSpan(text: 'Already have an account?', children: [
          TextSpan(
            text: "Log in",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.white,
            ),
          ),
        ]),
      ),
      const Spacer(),
    ],
  );
}
