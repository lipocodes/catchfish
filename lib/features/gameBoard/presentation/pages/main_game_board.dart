import 'package:flutter/material.dart';

class MainGameBoard extends StatefulWidget {
  const MainGameBoard({Key? key}) : super(key: key);

  @override
  State<MainGameBoard> createState() => _MainGameBoardState();
}

class _MainGameBoardState extends State<MainGameBoard> {
  @override
  Widget build(BuildContext context) {
    return const Text("Main Game Board");
  }
}
