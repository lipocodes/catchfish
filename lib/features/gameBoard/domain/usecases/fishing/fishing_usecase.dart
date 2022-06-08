// usecase class: an extending class to the abstract class
import 'dart:io';
import 'dart:math';

import 'package:catchfish/core/consts/fish.dart';
import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/caught_fish_entity.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
import 'package:catchfish/injection_container.dart';
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

  playEnteringScreenSound() {
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      playBackgroundAudio("goodLuck.mp3");
    }
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
        if (!Platform.environment.containsKey('FLUTTER_TEST')) {
          playBackgroundAudio("strongSignal.mp3");
        }
      } else {
        pulseLength = random / 10;
        double possibleAngleRange = (2.7925268 + 2.44346095);
        angle = (pulseLength * possibleAngleRange) - 2.7925268;
        if (!Platform.environment.containsKey('FLUTTER_TEST')) {
          playBackgroundAudio("weakSignal.mp3");
        }
      }
      double pulseStrength = 1.0;
      PulseEntity pulseEntity = PulseEntity(
          pulseStrength: pulseStrength, pulseLength: pulseLength, angle: angle);
      return Right(pulseEntity);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, CaughtFishEntity>> isFishCaught() async {
    int myLevel = 1;
    List<String> lotteryPool = [];
    try {
      bool isFishCaught = _isItCatchingTime;
      if (isFishCaught) {
        if (!Platform.environment.containsKey('FLUTTER_TEST')) {
          playBackgroundAudio("catchFish.mp3");
        }

        final res = await sl.get<FishingRepositoryImpl>().getLevelPref();

        res.fold((left) => Left(GeneralFailure()), (right) => myLevel = right);
        //now we have myLevel pref.  We need to randomize the caught fish type

        //principle: add once fishCategoryA, twice fishCategoryB, myLevel times fishCategoryC
        for (int a = 0; a < fishCategoryA.length; a++) {}
        for (int a = 0; a < fishCategoryB.length; a++) {
          lotteryPool.add(fishCategoryB[a]);
          lotteryPool.add(fishCategoryB[a]);
        }
        int neededIterations = 13 - myLevel;
        for (int a = 0; a < fishCategoryC.length; a++) {
          for (int b = 0; b < neededIterations; b++) {
            lotteryPool.add(fishCategoryC[a]);
          }
        }
        String caughtFishDetails =
            lotteryPool[Random().nextInt(lotteryPool.length) - 1];
        //add the new fish to the pref holding the personal shop inventory
        sl.get<CaughtFishEntity>().caughtFishDetails = caughtFishDetails;
        sl.get<CaughtFishEntity>().isFishCaught = true;
      } else {
        if (!Platform.environment.containsKey('FLUTTER_TEST')) {
          playBackgroundAudio("missedFish.mp3");
        }
      }

      return Right(
        sl.get<CaughtFishEntity>(),
      );
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
      if ((mins + ":" + secs) == "00:00") {
        playBackgroundAudio("gameOver.mp3");
      }
      return Right(mins + ":" + secs + "^^^" + levelEnergy.toString());
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, List<String>>> populatePersonalShop() async {
    final res = await sl.get<FishingRepositoryImpl>().getPersonalShopPref();
    List list1 = [];
    List<String> list2 = [];
    res.fold(
      (failure) => GeneralFailure(),
      (success) => list1 = success,
    );
    if (res.isRight()) {
      for (int a = 0; a < list1.length; a++) {
        list2.add(list1[a].toString());
      }
      return Right(list2);
    } else {
      return Left(GeneralFailure());
    }
  }
}
