import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/domain/repositories/fishing/fishing_repository.dart';
import 'package:catchfish/features/settings/data/datasources/remote_datasource.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';

class FishingRepositoryImpl implements FishingRepository {
  @override
  Future<Either<Failure, int>> getLevelPref() async {
    final res1 = await sl.get<LocalDatasourcePrefs>().getLevelPref();
    final res2 = await sl.get<RemoteDatasource>().getLevelPlayer();
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

  Future<Either<Failure, List>> getPersonalShop() async {
    final res1 = await sl.get<LocalDatasourcePrefs>().getPersonalShopPref();
    final res2 = await sl.get<RemoteDatasource>().getPersonalShop();
    //if app installation is not new && user has something in PersonalShop
    if (res1.isRight() && res1.length() > 0) {
      return res1;
    } else {
      if (res2.isRight()) {
        return res2;
      } else {
        return Left(GeneralFailure());
      }
    }
  }

  Future<Either<Failure, bool>> addFishPersonalShop(String fishDetails) async {
    final res1 =
        await sl.get<LocalDatasourcePrefs>().addFishPersonalShop(fishDetails);
    final res2 =
        await sl.get<RemoteDatasource>().addFishPersonalShop(fishDetails);
    if (res1.isRight() && res2.isRight()) {
      return const Right(true);
    } else {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> removeFishPersonalShop(
      String fishDetails) async {
    final res1 = await sl
        .get<LocalDatasourcePrefs>()
        .removeFishPersonalShop(fishDetails);
    final res2 =
        await sl.get<RemoteDatasource>().removeFishPersonalShop(fishDetails);
    if (res1.isRight() && res2.isRight()) {
      return const Right(true);
    } else {
      return Left(GeneralFailure());
    }
  }
}