import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';

import 'package:dartz/dartz.dart';

import '../../../data/datasources/fishing/remote_datasource.dart';

//shouyld be tested by Mockito
abstract class FishingRepository {
  Future<Either<Failure, bool>> updateLevel(
      int newLevel,
      LocalDatasourcePrefs localDatasourcePrefs,
      RemoteDatasource remoteDatasource);
  Future<Either<Failure, int>> getLevelPref(
      LocalDatasourcePrefs localDatasourcePrefs,
      RemoteDatasource remoteDatasource);
  Future<Either<Failure, List>> getPersonalShop(
      LocalDatasourcePrefs localDatasourcePrefs,
      RemoteDatasource remoteDatasource);
  Future<Either<Failure, bool>> addFishPersonalShop(String caughtFishDetails);
  Future<Either<Failure, bool>> removeFishPersonalShop(
      String fishDetails,
      LocalDatasourcePrefs localDatasourcePrefs,
      RemoteDatasource remoteDatasource);
  Future<Either<Failure, bool>> deleteGroup(
      String groupName, RemoteDatasource remoteDatasource);
  Future<Either<Failure, bool>> addPlayerToGroup(
      String groupName, RemoteDatasource remoteDatasource);
  Future<Either<Failure, List>> getPlayersForSelectedGroup(
      String selectedGroupName, RemoteDatasource remoteDatasource);
  Future<Either<Failure, List>> getExistingGroups(
      RemoteDatasource remoteDatasource);
}
