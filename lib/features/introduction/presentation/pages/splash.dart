import 'dart:async';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/introduction/presentation/blocs/bloc/introduction_bloc.dart';
import 'package:catchfish/features/introduction/presentation/widgets/boat_steering.dart';
import 'package:catchfish/features/introduction/presentation/widgets/flying_bird.dart';
import 'package:catchfish/features/introduction/presentation/widgets/text_loading.dart';
import 'package:catchfish/features/login/presentation/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late IntroductionBloc _bloc;
  bool _isTimerSet = false;
  double rightPositionBird = 80.0;
  double topPositionBird = 120.0;

  late AnimationController animationController;
  double steeringAngle = 0;
  int enumerator = 0;
  int remainingMilliseconds = 5000;
  bool colorLoadingText = false;
  late PlaySound playSound;

  @override
  void initState() {
    super.initState();

    playSound = PlaySound();
    playSound.play(path: "assets/sounds/introduction/", fileName: "tweet.mp3");
  }

  setTimer(BuildContext context) async {
    if (_isTimerSet) {
      return;
    }

    _isTimerSet = true;
    _bloc = BlocProvider.of<IntroductionBloc>(context);
    _bloc.add(LoadingEvent());
    Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      if (remainingMilliseconds == 0) {
        t.cancel();

        //Navigator.pushNamed(context, '/lobby');
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );*/
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

        if (rightPositionBird >= 10.0) {
          //rightPositionBird -= 10.0;
          //topPositionBird -= 10.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setTimer(context);
    return SafeArea(
      child: BlocBuilder<IntroductionBloc, IntroductionState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      //tenor.com
                      'assets/images/introduction/waves.gif',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    boatSteering(context, steeringAngle),
                    const SizedBox(
                      height: 50.0,
                    ),
                    textLoading(context, colorLoadingText),
                  ],
                ),
              ),
              if (rightPositionBird > 0.0) ...[
                flyingBird(topPositionBird, rightPositionBird),
              ],
            ]),
          );
        },
      ),
    );
  }
}
