import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double rightPositionBird1 = 300.0;
  double topPositionBird1 = 300.0;
  double rightPositionBird2 = 300.0;
  double topPositionBird2 = 300.0;
  double rightPositionBird3 = 300.0;
  double topPositionBird3 = 0.0;
  double topPositionBird4 = 600.0;
  double rightPositionBird4 = 300.0;
  late AudioPlayer advancedPlayer;
  late AudioCache audioCache;

  playSound() async {
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(
        fixedPlayer: advancedPlayer, prefix: 'assets/sounds/introduction/');
    await audioCache.play("tweet.mp3");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSound();

    Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      setState(() {
        if (rightPositionBird1 >= 10.0) {
          rightPositionBird1 -= 10.0;
          topPositionBird1 -= 10.0;
        }

        if (rightPositionBird2 >= 10) {
          rightPositionBird2 -= 10.0;
          topPositionBird2 += 10.0;
        }
        if (rightPositionBird3 >= 10) {
          rightPositionBird3 -= 10.0;
          topPositionBird3 += 10.0;
        }
        if (rightPositionBird4 >= 10) {
          rightPositionBird4 -= 10.0;
          topPositionBird4 -= 10.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Image.asset(
                  'assets/images/introduction/boat_steering.png',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: const Text("asdasdasdasdasdasda"),
              ),
            ],
          ),
          if (rightPositionBird1 > 0.0) ...[
            Positioned(
              top: topPositionBird1,
              right: rightPositionBird1,
              child: SizedBox(
                height: 100,
                child: Image.asset(
                  'assets/images/introduction/flying_bird.gif',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            )
          ],
          if (rightPositionBird2 > 0.0) ...[
            Positioned(
              top: topPositionBird2,
              right: rightPositionBird2,
              child: SizedBox(
                height: 100,
                child: Image.asset(
                  'assets/images/introduction/flying_bird.gif',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            )
          ],
          if (rightPositionBird3 > 0.0) ...[
            Positioned(
              top: topPositionBird3,
              right: rightPositionBird3,
              child: SizedBox(
                height: 100,
                child: Image.asset(
                  'assets/images/introduction/flying_bird.gif',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            )
          ],
          if (rightPositionBird3 > 0.0) ...[
            Positioned(
              top: topPositionBird3,
              right: rightPositionBird3,
              child: SizedBox(
                height: 100,
                child: Image.asset(
                  'assets/images/introduction/flying_bird.gif',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            )
          ],
        ]),
      ),
    );
  }
}
