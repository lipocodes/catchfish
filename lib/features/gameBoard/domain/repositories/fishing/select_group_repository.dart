import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/list_group_model.dart';
import 'package:catchfish/features/gameBoard/data/models/fishing/multipleplayer_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SelectGroupRepository {
  Future<Either<Failure, ListGroupModel>> retreiveListGroups(
      RemoteDatasource remoteDatasource);
  Future<Either<Failure, bool>> createNewGroup(
    String groupName,
    String yourName,
    RemoteDatasource remoteDatasource,
    LocalDatasourcePrefs localDatasourcePrefs,
  );
  Future<Either<Failure, bool>> addUserToGroup(
      String groupName, String yourName, RemoteDatasource remoteDatasource);
  Future<Either<Failure, bool>> joinMultiplayerGame(
      {required RemoteDatasource remoteDatasource});
  Future<Either<Failure, bool>> quitMultiplayerGame(
      {required RemoteDatasource remoteDatasource});
  Future<Either<Failure, MultipleplayerModel>> getUpdateMultiplayerGame(
      {required RemoteDatasource remoteDatasource});
}
