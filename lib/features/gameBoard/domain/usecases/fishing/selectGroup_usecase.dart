import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/list_group_entity.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:catchfish/injection_container.dart';

class SelectGroupUsecase extends UseCase<PulseEntity, NoParams> {
  @override
  Future<Either<Failure, PulseEntity>> call(NoParams params) {
    throw UnimplementedError();
  }

  Future<Either<Failure, ListGroupEntity>> retreiveListGroups(
      SelectGroupRepositoryImpl selectGroupRepositoryImpl) async {
    try {
      late ListGroupEntity listGroupEntity = ListGroupEntity(list: []);
      final res = await selectGroupRepositoryImpl.retreiveListGroups();

      res.fold(
        (failure) => GeneralFailure(),
        (success) => listGroupEntity.list = success.list,
      );
      return Right(listGroupEntity);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
