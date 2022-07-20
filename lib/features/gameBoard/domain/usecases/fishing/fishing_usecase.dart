// usecase class: an extending class to the abstract class
import 'dart:io';
import 'dart:math';

import 'package:catchfish/core/consts/fish.dart';
import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
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
  late LocalDatasourcePrefs localDatasourcePrefs = LocalDatasourcePrefs();
  late RemoteDatasource remoteDatasource;

  FishingUsecase();

  playBackgroundAudio(String engineSound) async {
    audioPlayer = await audioCache.play(engineSound);
  }

  Future<Either<GeneralFailure, int>> retreiveNumPlayers() async {
    try {
      int numPlayers = 0;
      int timeNow = DateTime.now().millisecond;
      if (timeNow % 1 == 0) {
        final res = await sl.get<FishingRepositoryImpl>().retreiveNumPlayers();
        res.fold((l) => GeneralFailure(), (r) => numPlayers = r);
        return Right(numPlayers);
      } else {
        return Right(numPlayers);
      }
    } catch (e) {
      return Left(GeneralFailure());
    }
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

  playTypingSound() {
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      playBackgroundAudio("typing.mp3");
    }
  }

  playKaboomSound() {
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      playBackgroundAudio("kaboom.mp3");
    }
  }

  playCoinSound() {
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      playBackgroundAudio("coin.mp3");
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
        localDatasourcePrefs = LocalDatasourcePrefs();
        remoteDatasource = RemoteDatasource();
        final res = await sl
            .get<FishingRepositoryImpl>()
            .getLevelPref(localDatasourcePrefs, remoteDatasource);

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
        sl.get<LocalDatasourcePrefs>().addFishPersonalShop(caughtFishDetails);
        sl.get<CaughtFishEntity>().caughtFishDetails = caughtFishDetails;
        sl.get<CaughtFishEntity>().isFishCaught = true;
        return Right(
          sl.get<CaughtFishEntity>(),
        );
      } else {
        if (!Platform.environment.containsKey('FLUTTER_TEST')) {
          playBackgroundAudio("missedFish.mp3");
        }
      }

      return Left(GeneralFailure());
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, String>> calculateNewCoundownTime(
      String currentCountdownTime) async {
    try {
      bool gameStarted = false;
      final res = await sl.get<FishingRepositoryImpl>().hasGameStarted();
      res.fold((l) => Left(GeneralFailure()), (r) => gameStarted = r);

      int minutes = int.parse(currentCountdownTime.substring(0, 2));
      int seconds = int.parse(currentCountdownTime.substring(3));
      int levelEnergy = 0;
      if (seconds >= 0 && seconds < 12) {
        levelEnergy = 0;
      } else if (seconds >= 12 && seconds < 24) {
        levelEnergy = 1;
      } else if (seconds >= 24 && seconds < 36) {
        levelEnergy = 2;
      } else if (seconds >= 36 && seconds < 48) {
        levelEnergy = 3;
      } else if (seconds >= 48 && seconds <= 60) {
        levelEnergy = 4;
      }

      if (seconds > 0 && gameStarted) {
        seconds -= 1;
      } else if (gameStarted) {
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

  Future<Either<Failure, List<String>>> populatePersonalShop(
      RemoteDatasource remoteDatasource,
      LocalDatasource localDatasource) async {
    final res = await sl
        .get<FishingRepositoryImpl>()
        .getPersonalShop(localDatasourcePrefs, remoteDatasource);

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

  Future<Either<Failure, List<String>>> populatePersonalCollection(
      RemoteDatasource remoteDatasource,
      LocalDatasource localDatasource,
      String email) async {
    final res = await sl
        .get<FishingRepositoryImpl>()
        .getPersonalCollection(localDatasourcePrefs, remoteDatasource, email);

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

  Future<Either<Failure, bool>> moveToPersonalCollection(
      int index, FishingUsecase fishingUsecase) async {
    try {
      bool yesNo = false;
      final res = await sl
          .get<FishingRepositoryImpl>()
          .moveToPersonalCollection(index, sl.get<RemoteDatasource>());

      res.fold(
        (failure) => GeneralFailure(),
        (success) => yesNo = success,
      );
      if (res.isRight()) {
        playKaboomSound();
        return Right(yesNo);
      } else {
        return Left(GeneralFailure());
      }
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, List<String>>> searchOtherPlayers(String text) async {
    try {
      playTypingSound();
      List<String> relevantPlayers = [];
      final res = await sl
          .get<FishingRepositoryImpl>()
          .searchOtherPlayers(text, sl.get<RemoteDatasource>());

      res.fold(
        (failure) => GeneralFailure(),
        (success) => relevantPlayers = success,
      );
      if (res.isRight()) {
        return Right(relevantPlayers);
      } else {
        return Left(GeneralFailure());
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeee usecase searchOtherPlayers()" + e.toString());
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> sendPriceOfferCollectionFishEvent(
      String emailBuyer,
      String price,
      String emailSeller,
      int fishIndex,
      FishingUsecase fishingUsecase) async {
    try {
      bool yesNo = false;
      final res = await sl
          .get<FishingRepositoryImpl>()
          .sendPriceOfferCollectionFishEvent(emailBuyer, price, emailSeller,
              fishIndex, sl.get<RemoteDatasource>());
      res.fold(
        (failure) => GeneralFailure(),
        (success) => yesNo = success,
      );
      if (res.isRight()) {
        playCoinSound();
        return Right(yesNo);
      } else {
        return Left(GeneralFailure());
      }
    } catch (e) {
      print("eeeeeeeeeeeee usecase sendPriceOfferCollectionFishEvent=" +
          e.toString());
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> acceptPriceOfferCollectionFish(
      String emailBuyer,
      String price,
      int fishIndex,
      FishingUsecase fishingUsecase) async {
    try {
      bool yesNo = false;
      final res = await sl
          .get<FishingRepositoryImpl>()
          .acceptPriceOfferCollectionFish(
              emailBuyer, price, fishIndex, sl.get<RemoteDatasource>());
      res.fold(
        (failure) => GeneralFailure(),
        (success) => yesNo = success,
      );
      if (res.isRight()) {
        if (yesNo == true) {
          playKaboomSound();
        }

        return Right(yesNo);
      } else {
        return Left(GeneralFailure());
      }
    } catch (e) {
      print("eeeeeeeeeeeee usecase acceptPriceOfferCollectionFish=" +
          e.toString());
      return Left(GeneralFailure());
    }
  }

  changeShowCollection(String show) async {
    try {
      sl
          .get<FishingRepositoryImpl>()
          .changeShowCollection(show, sl.get<RemoteDatasource>());
    } catch (e) {
      print("eeeeeeeeeeeeee usecase changeShowCollection=" + e.toString());
    }
  }

  Future<Either<Failure, bool>> updateCaughtInGroups(
      String caughtFishDetails) async {
    try {
      bool yesNo = false;
      final res = await sl
          .get<FishingRepositoryImpl>()
          .updateCaughtFishInGroups(caughtFishDetails);
      res.fold((l) => Left(GeneralFailure()), (r) => yesNo = r);
      return Right(yesNo);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> addFishPersonalShop(
      String caughtFishDetails) async {
    try {
      bool yesNo = false;
      final res = await sl
          .get<FishingRepositoryImpl>()
          .addFishPersonalShop(caughtFishDetails);
      res.fold((l) => Left(GeneralFailure()), (r) => yesNo = r);
      return Right(yesNo);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, List<String>>> getGameResults(
      FishingRepositoryImpl fishingRepositoryImpl) async {
    List<String> listAcheivements = [];
    try {
      final res = await fishingRepositoryImpl.getGameResults();
      res.fold((l) => Left(GeneralFailure()), (r) => listAcheivements = r);
      return Right(listAcheivements);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> hasGameStarted() async {
    try {
      bool yesNo = false;
      final res = await sl.get<FishingRepositoryImpl>().hasGameStarted();
      res.fold((l) => GeneralFailure(), (r) => yesNo = r);
      return Right(yesNo);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, String>> getGroupLeader() async {
    try {
      String groupLeader = "";
      final res = await sl.get<FishingRepositoryImpl>().getGroupLeader();
      res.fold((l) => GeneralFailure(), (r) => groupLeader = r);

      return Right(groupLeader);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, bool>> startGame() async {
    try {
      bool yes_no = false;
      final res = await sl.get<FishingRepositoryImpl>().startGame();
      res.fold((l) => GeneralFailure(), (r) => yes_no = r);
      return Right(yes_no);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, String>> getNamePlayerCaughtFish() async {
    try {
      String namePlayerCaughFish = "";
      final res =
          await sl.get<FishingRepositoryImpl>().getNamePlayerCaughtFish();
      res.fold((l) => GeneralFailure(), (r) => namePlayerCaughFish = r);
      return Right(namePlayerCaughFish);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, List>> rejectPriceOffer(
      int index, FishingRepositoryImpl fishingRepositoryImpl) async {
    List listItems = [];
    try {
      RemoteDatasource remoteDatasource = RemoteDatasource();
      final res =
          await fishingRepositoryImpl.rejectPriceOffer(index, remoteDatasource);
      res.fold((l) => GeneralFailure(), (r) => listItems = r);
      return Right(listItems);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, List>> acceptPriceOffer(
      int index, FishingRepositoryImpl fishingRepositoryImpl) async {
    List listItems = [];
    try {
      RemoteDatasource remoteDatasource = RemoteDatasource();
      final res =
          await fishingRepositoryImpl.acceptPriceOffer(index, remoteDatasource);
      res.fold((l) => GeneralFailure(), (r) => listItems = r);
      return Right(listItems);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
