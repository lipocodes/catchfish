import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDatasource {}

class LocalDatasourcePrefs implements LocalDatasource {
  Future<Either<Failure, bool>> updateLevelPref(int newLevel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt("myLevel", newLevel);
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, int>> getLevelPref() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final res = prefs.getInt("myLevel") ?? 1;
      return Right(res);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, List>> getPersonalShopPref() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var res = prefs.getStringList("personalShop") ?? [];

      return Right(res);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> addFishPersonalShop(String detailsFish) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final res = prefs.getStringList("personalShop") ?? [];
      res.add(detailsFish);
      prefs.setStringList("personalShop", res);
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }

  Future<Either<Failure, bool>> removeFishPersonalShop(
      String detailsFish) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final res = prefs.getStringList("personalShop") ?? [];
      res.remove(detailsFish);
      prefs.setStringList("personalShop", res);
      return const Right(true);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
