import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/repositories/select_group_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/list_group_entity.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
import 'package:catchfish/features/settings/data/datasources/remote_datasource.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';

class SelectGroupUsecase extends UseCase<PulseEntity, NoParams> {
  @override
  Future<Either<Failure, PulseEntity>> call(NoParams params) {
    throw UnimplementedError();
  }

  Future<Either<Failure, ListGroupEntity>> retreiveListGroups(
      SelectGroupRepositoryImpl selectGroupRepositoryImpl) async {
    try {
      late ListGroupEntity listGroupEntity = ListGroupEntity(list: []);
      final res = await selectGroupRepositoryImpl
          .retreiveListGroups(sl.get<RemoteDatasource>());

      res.fold(
        (failure) => GeneralFailure(),
        (success) => listGroupEntity.list = success.list,
      );
      return Right(listGroupEntity);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> addUserToGroup(
      String groupName,
      String yourName,
      SelectGroupRepositoryImpl selectGroupRepositoryImpl) async {
    try {
      bool yesNo = false;
      RemoteDatasource remoteDatasource = RemoteDatasource();
      final res = await selectGroupRepositoryImpl.addUserToGroup(
          groupName, yourName, remoteDatasource);
      res.fold((l) => Left(GeneralFailure()), (r) => yesNo = r);
      return Right(yesNo);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> createNewGroup(
      String groupName,
      String yourName,
      SelectGroupRepositoryImpl selectGroupRepositoryImpl) async {
    try {
      bool yesNo = false;
      final res = await selectGroupRepositoryImpl.createNewGroup(
          groupName, yourName, sl.get<RemoteDatasource>());
      res.fold((l) => Left(GeneralFailure()), (r) => yesNo = r);
      return Right(yesNo);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
