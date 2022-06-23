import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/domain/repositories/fishing/select_group_repository.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';

class SelectGroupRepositoryImpl implements SelectGroupRepository {
  @override
  Future<Either<Failure, ListGroupModel>> retreiveListGroups(
      RemoteDatasource remoteDatasource) async {
    try {
      ListGroupModel listGroupModel = ListGroupModel(list: []);
      final res = await remoteDatasource.retreiveListGroups();
      res.fold(
          (failure) => GeneralFailure(), (success) => listGroupModel = success);

      return Right(listGroupModel);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> addUserToGroup(String groupName,
      String yourName, RemoteDatasource remoteDatasource) async {
    try {
      bool yesNo = false;
      final res = await remoteDatasource.addUserToGroup(groupName, yourName);
      res.fold((l) => GeneralFailure(), (r) => yesNo = r);
      return Right(yesNo);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> createNewGroup(
    String groupName,
    String yourName,
    RemoteDatasource remoteDatasource,
    LocalDatasourcePrefs localDatasourcePrefs,
  ) async {
    try {
      bool yesNo1 = false;
      bool yesNo2 = false;
      final res1 = await remoteDatasource.createNewGroup(groupName, yourName);
      res1.fold((l) => GeneralFailure(), (r) => yesNo1 = r);
      final res2 = await localDatasourcePrefs.createNewGroup();
      res2.fold((l) => GeneralFailure(), (r) => yesNo2 = r);
      if (yesNo1 && yesNo2) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
