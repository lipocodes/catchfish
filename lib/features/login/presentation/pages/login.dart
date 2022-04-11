import 'package:catchfish/features/introduction/presentation/pages/splash.dart';
import 'package:catchfish/features/lobby/presentation/pages/lobby.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //custom BACK operation
  performBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Something Went Wrong!"));
          } else if (snapshot.hasData) {
            performBack();
          }
          //else: if we haven't called the Provider yet
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const FlutterLogo(size: 120.0),
                    const Spacer(),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Hey there,\n Welcome back!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(height: 8.00),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Login to your account to continue!",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        )),
                    const Spacer(),
                    ElevatedButton.icon(
                      label: const Text("Sign Up with Google"),
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.googleLogin();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          minimumSize: const Size(double.infinity, 50)),
                      icon: const FaIcon(FontAwesomeIcons.google,
                          color: Colors.blue),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    RichText(
                      text: const TextSpan(
                          text: 'Already have an account?',
                          children: [
                            TextSpan(
                              text: "Log in",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ]),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
