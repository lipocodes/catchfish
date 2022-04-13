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
            /*final provider1 =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider1.googleLogout();
            final provider2 =
                Provider.of<FacebookSignInProvider>(context, listen: false);
            provider2.facebookLogout();*/

            performBack();
          }
          //else: if we haven't called the Provider yet
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                height: 1000,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      //tenor.com
                      'assets/images/login/rope.jpg',
                    ),
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
