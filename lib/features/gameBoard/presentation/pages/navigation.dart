import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_back.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: buttonBack(context),
              actions: [],
            ),
            resizeToAvoidBottomInset: false,
            body: const Text("Navigation")));
  }
}
