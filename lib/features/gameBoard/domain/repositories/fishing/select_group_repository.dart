import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:dartz/dartz.dart';

abstract class SelectGroupRepository {
  Future<Either<Failure, ListGroupModel>> retreiveListGroups(
      RemoteDatasource remoteDatasource);
  Future<Either<Failure, bool>> createNewGroup(
    String groupName,
    String yourName,
    RemoteDatasource remoteDatasource,
  );
  Future<Either<Failure, bool>> addUserToGroup(
      String groupName, String yourName, RemoteDatasource remoteDatasource);
}
