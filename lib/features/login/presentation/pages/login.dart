import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
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
              ElevatedButton(
                child: const Text("Sign Up with Google"),
                onPressed: () {
                  print("aaaaaaaaaaaaaaaaaaa");
                },
              ),
              const SizedBox(
                height: 40.0,
              ),
              RichText(
                text:
                    const TextSpan(text: 'Already have an account?', children: [
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
  }
}
