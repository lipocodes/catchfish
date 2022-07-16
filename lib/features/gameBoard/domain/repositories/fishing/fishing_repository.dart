import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart';

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
  Future<Either<Failure, List<String>>> getGameResults();
  Future<Either<Failure, List>> getPersonalCollection(
      LocalDatasourcePrefs localDatasourcePrefs,
      RemoteDatasource remoteDatasource,
      String email);
  Future<Either<Failure, bool>> moveToPersonalCollection(
      int index, RemoteDatasource remoteDatasource);
  Future<Either<Failure, List<String>>> searchOtherPlayers(
      String text, RemoteDatasource remoteDatasource);
  Future<Either<Failure, bool>> sendPriceOfferCollectionFishEvent(
      String emailBuyer,
      String price,
      String emailSeller,
      int fishIndex,
      RemoteDatasource remoteDatasource);
}
