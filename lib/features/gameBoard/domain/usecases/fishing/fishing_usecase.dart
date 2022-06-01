// usecase class: an extending class to the abstract class
import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
import 'package:dartz/dartz.dart';

class FishingUsecase extends UseCase<PulseEntity, NoParams> {
  FishingUsecase();

  @override
  Future<Either<Failure, PulseEntity>> call(NoParams params) async {
    //return await repository.getPulse();
    return Right(PulseEntity(pulseLength: 1.0, pulseStrength: 1.0));
  }

  Either<Failure, PulseEntity> getPulse() {
    PulseEntity pulseEntity = PulseEntity(pulseStrength: 1.0, pulseLength: 0.1);
    return Right(pulseEntity);
    //return Left(GeneralFailure());
  }
}
