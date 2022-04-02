import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
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
  late AnimationController animationController;
  double steeringAngle = 0;
  int enumerator = 0;
  int remainingMilliseconds = 5000;
  bool colorLoadingText = false;

  playSound() async {
    final prefs = await SharedPreferences.getInstance();
    bool permissionAudio = prefs.getBool("permissionAudio") ?? true;
    if (permissionAudio) {
      advancedPlayer = AudioPlayer();
      audioCache = AudioCache(
          fixedPlayer: advancedPlayer, prefix: 'assets/sounds/introduction/');
      await audioCache.play("tweet.mp3");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSound();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    animationController.repeat();

    Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      if (remainingMilliseconds == 0) {
        t.cancel();
      } else {
        remainingMilliseconds -= 100;
      }
      setState(() {
        enumerator++;
        if (enumerator < 5) {
          steeringAngle += 0.3;
          colorLoadingText = true;
        } else if (enumerator < 15) {
        } else if (enumerator < 25) {
          steeringAngle -= 0.3;
          colorLoadingText = false;
        } else {
          enumerator = 0;
        }

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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/introduction/fishing_boat.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  //width: MediaQuery.of(context).size.width * 0.9,
                  child: Transform.rotate(
                    angle: steeringAngle,
                    child: Image.asset(
                      'assets/images/introduction/boat_steering.png',
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                colorLoadingText
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: const Text(
                          "loading",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.brown,
                          ),
                        ).tr(),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: const Text(
                          "loading",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.yellow,
                          ),
                        ).tr(),
                      ),
              ],
            ),
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
          if (rightPositionBird4 > 0.0) ...[
            Positioned(
              top: topPositionBird4,
              right: rightPositionBird4,
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
