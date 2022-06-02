// usecase class: an extending class to the abstract class
import 'dart:math';

import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FishingUsecase extends UseCase<PulseEntity, NoParams> {
  late SharedPreferences _prefs;
  FishingUsecase();

  @override
  Future<Either<Failure, PulseEntity>> call(NoParams params) async {
    //return await repository.getPulse();
    return Right(PulseEntity(pulseLength: 1.0, pulseStrength: 1.0));
  }

  Future<Either<Failure, PulseEntity>> getPulse() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int myLevel = prefs.getInt("myLevel") ?? 1;
      double pulseLength = 0.0;
      int random = Random().nextInt(10);
      if (random == 10) {
        pulseLength = 2 - myLevel * 0.1;
      } else {
        pulseLength = random / 10;
      }
      double pulseStrength = 1.0;
      PulseEntity pulseEntity =
          PulseEntity(pulseStrength: pulseStrength, pulseLength: pulseLength);
      return Right(pulseEntity);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
