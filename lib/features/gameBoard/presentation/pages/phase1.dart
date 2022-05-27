import 'package:flutter/material.dart';

class Phase1 extends StatefulWidget {
  const Phase1({Key? key}) : super(key: key);

  @override
  State<Phase1> createState() => _Phase1State();
}

class _Phase1State extends State<Phase1> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: const Text("המסך הבא - אלי, אני צריך חוקים",
            style: TextStyle(fontSize: 32.0, color: Colors.white)));
  }
}
