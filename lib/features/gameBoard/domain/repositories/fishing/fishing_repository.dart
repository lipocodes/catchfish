import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
import 'package:dartz/dartz.dart';

//shouyld be tested by Mockito
abstract class FishingRepository {
  Future<Either<Failure, int>> getLevelPref();
}
