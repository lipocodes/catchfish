import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/login/presentation/widgets/form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //custom BACK operation
  performBack() async {
    Navigator.pop(context);
    //Navigator.of(context).popUntil(ModalRoute.withName("/"));
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
                child: form(context),
              ),
            ),
          );
        });
  }
}
