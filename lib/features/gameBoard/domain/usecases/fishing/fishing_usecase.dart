// usecase class: an extending class to the abstract class
import 'dart:math';

import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class FishingUsecase extends UseCase<PulseEntity, NoParams> {
  late SharedPreferences _prefs;
  final AudioCache audioCache = AudioCache(prefix: "assets/sounds/gameBoard/");
  AudioPlayer audioPlayer = AudioPlayer();
  bool _isItCatchingTime = false;
  FishingUsecase();

  playBackgroundAudio(String engineSound) async {
    audioPlayer = await audioCache.play(engineSound);
  }

  @override
  Future<Either<Failure, PulseEntity>> call(NoParams params) async {
    //return await repository.getPulse();
    return const Right(
        PulseEntity(pulseLength: 1.0, pulseStrength: 1.0, angle: 0.0));
  }

  Future<Either<Failure, PulseEntity>> getPulse() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int myLevel = prefs.getInt("myLevel") ?? 1;
      double pulseLength = 0.0;
      double angle = 0.0;
      int random = 1 + Random().nextInt(10);
      if (random == 10) {
        pulseLength = 2 - myLevel * 0.1;
        angle = 2.7925268;
        _isItCatchingTime = true;
        int milli = (pulseLength * 1000).toInt();
        Future.delayed(Duration(milliseconds: milli), () {
          _isItCatchingTime = false;
        });
        playBackgroundAudio("strongSignal.mp3");
      } else {
        pulseLength = random / 10;
        double possibleAngleRange = (2.7925268 + 2.44346095);
        angle = (pulseLength * possibleAngleRange) - 2.7925268;
        playBackgroundAudio("weakSignal.mp3");
      }
      double pulseStrength = 1.0;
      PulseEntity pulseEntity = PulseEntity(
          pulseStrength: pulseStrength, pulseLength: pulseLength, angle: angle);
      return Right(pulseEntity);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> isFishCaught() async {
    try {
      bool isFishCaught = _isItCatchingTime;
      return Right(isFishCaught);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, String>> calculateNewCoundownTime(
      FishingUsecase fishingUsecase, String currentCountdownTime) async {
    try {
      int minutes = int.parse(currentCountdownTime.substring(0, 2));
      int seconds = int.parse(currentCountdownTime.substring(3));
      int levelEnergy = minutes;

      if (seconds > 0) {
        seconds -= 1;
      } else {
        seconds = 59;
        minutes -= 1;
      }
      String mins = minutes.toString();
      if (mins.length < 2) {
        mins = "0" + mins;
      }
      String secs = seconds.toString();
      if (secs.length < 2) {
        secs = "0" + secs;
      }

      return Right(mins + ":" + secs + "^^^" + levelEnergy.toString());
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
