import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/domain/repositories/fishing/fishing_repository.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';

class FishingRepositoryImpl implements FishingRepository {
  @override
  Future<Either<Failure, bool>> updateLevel(
      int newLevel,
      LocalDatasourcePrefs localDatasourcePrefs,
      RemoteDatasource remoteDatasource) async {
    final res1 = await localDatasourcePrefs.updateLevelPref(newLevel);
    final res2 = await remoteDatasource.updateLevelPlayer(newLevel);
    if (res1.isRight() && res2.isRight()) {
      return const Right(true);
    } else {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getLevelPref(
      LocalDatasourcePrefs localDatasourcePrefs,
      RemoteDatasource remoteDatasource) async {
    final res1 = await localDatasourcePrefs.getLevelPref();
    final res2 = await remoteDatasource.getLevelPlayer();
    int val1 = 0;
    int val2 = 0;
    if (res1.isRight() && res2.isRight()) {
      res1.fold((failure) => null, (success) => val1 = success);
      res2.fold((failure) => null, (success) => val2 = success);
      //if level on DB is greater than level on pref
      if (val1 < val2) {
        return Right(val1);
      } else {
        return Right(val2);
      }
    } else {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getPersonalShop(
      LocalDatasourcePrefs localDatasourcePrefs,
      RemoteDatasource remoteDatasource) async {
    final res = await remoteDatasource.getPersonalShop();
    //if app installation is not new && user has something in PersonalShop
    if (res.isRight()) {
      return res;
    } else {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getPersonalCollection(
      LocalDatasourcePrefs localDatasourcePrefs,
      RemoteDatasource remoteDatasource) async {
    final res = await remoteDatasource.getPersonalCollection();
    //if app installation is not new && user has something in PersonalShop
    if (res.isRight()) {
      return res;
    } else {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeFishPersonalShop(
      String fishDetails,
      LocalDatasourcePrefs localDatasourcePrefs,
      RemoteDatasource remoteDatasource) async {
    final res1 = await localDatasourcePrefs.removeFishPersonalShop(fishDetails);
    final res2 = await remoteDatasource.removeFishPersonalShop(fishDetails);
    if (res1.isRight() && res2.isRight()) {
      return const Right(true);
    } else {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteGroup(
      String groupName, RemoteDatasource remoteDatasource) async {
    final res = await remoteDatasource.deleteGroup(groupName);
    if (res.isRight()) {
      return const Right(true);
    } else {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> addPlayerToGroup(
      String groupName, RemoteDatasource remoteDatasource) async {
    final res = await remoteDatasource.addPlayerToGroup(groupName);
    if (res.isRight()) {
      return const Right(true);
    } else {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getPlayersForSelectedGroup(
      String selectedGroupName, RemoteDatasource remoteDatasource) async {
    final res =
        await remoteDatasource.getPlayersForSelectedGroup(selectedGroupName);
    if (res.isRight()) {
      return res;
    } else {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, List>> getExistingGroups(
      RemoteDatasource remoteDatasource) async {
    final res = await remoteDatasource.getExistingGroups();
    if (res.isRight()) {
      return res;
    } else {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateCaughtFishInGroups(
      String caughtFishDetails) async {
    try {
      sl.get<RemoteDatasource>().updateCaughtFishInGroups(caughtFishDetails);
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> addFishPersonalShop(
      String caughtFishDetails) async {
    try {
      sl.get<RemoteDatasource>().addFishPersonalShop(caughtFishDetails);
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getGameResults() async {
    try {
      List<String> listAcheivements = [];
      final res = await sl.get<RemoteDatasource>().getGameResults();
      res.fold((l) => Left(GeneralFailure()), (r) => listAcheivements = r);
      return Right(listAcheivements);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, int>> retreiveNumPlayers() async {
    try {
      int numPlayers = 0;
      final res = await sl.get<RemoteDatasource>().retreiveNumPlayers();
      res.fold((l) => GeneralFailure(), (r) => numPlayers = r);
      return Right(numPlayers);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, bool>> hasGameStarted() async {
    try {
      bool yesNo = false;
      final res = await sl.get<RemoteDatasource>().hasGameStarted();
      res.fold((l) => GeneralFailure(), (r) => yesNo = r);
      return Right(yesNo);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, String>> getGroupLeader() async {
    try {
      String groupLeader = "";
      final res = await sl.get<RemoteDatasource>().getGroupLeader();

      res.fold((l) => GeneralFailure(), (r) => groupLeader = r);

      return Right(groupLeader);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, bool>> startGame() async {
    try {
      bool yes_no = false;
      final res = await sl.get<RemoteDatasource>().startGame();
      res.fold((l) => GeneralFailure(), (r) => yes_no = r);
      return Right(yes_no);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, String>> getNamePlayerCaughtFish() async {
    try {
      String namePlayerCaughtFish = "";
      final res = await sl.get<RemoteDatasource>().getNamePlayerCaughtFish();
      res.fold((l) => GeneralFailure(), (r) => namePlayerCaughtFish = r);
      return Right(namePlayerCaughtFish);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, List>> rejectPriceOffer(
      int index, RemoteDatasource remoteDatasource) async {
    List listItems = [];
    try {
      final res = await remoteDatasource.rejectPriceOffer(index);
      res.fold((l) => GeneralFailure(), (r) => listItems = r);
      return Right(listItems);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<GeneralFailure, List>> acceptPriceOffer(
      int index, RemoteDatasource remoteDatasource) async {
    List listItems = [];
    try {
      final res = await remoteDatasource.acceptPriceOffer(index);
      res.fold((l) => GeneralFailure(), (r) => listItems = r);
      return Right(listItems);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
