import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/domain/repositories/fishing/select_group_repository.dart';

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
}
