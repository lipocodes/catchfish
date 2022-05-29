import 'package:catchfish/features/gameBoard/presentation/widgets/fishing/pulse_generator.dart';
import 'package:flutter/material.dart';

class Fishing extends StatefulWidget {
  const Fishing({Key? key}) : super(key: key);

  @override
  State<Fishing> createState() => _FishingState();
}

class _FishingState extends State<Fishing> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pulseGenerator(),
      ],
    );
  }
}
