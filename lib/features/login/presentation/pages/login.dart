import 'package:catchfish/features/login/presentation/widgets/form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    AssetImage backgroundImage =
        const AssetImage("assets/images/login/rope.jpg");
    precacheImage(backgroundImage, context);
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
              extendBodyBehindAppBar: true,
              //backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              //in core/widgets/main_menu.dart
              //drawer: mainMenu(context),
              body: Container(
                height: 1000,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: backgroundImage,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: form(context),
                ),
              ),
            ),
          );
        });
  }
}
