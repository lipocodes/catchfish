import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDatasource {}

class LocalDatasourcePrefs implements LocalDatasource {
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
      res = [
        "Sargo^^^10^^^100^^^sargo.jpg",
        "Sardin^^^15^^^150^^^sardin.jpg",
        "Mullet^^^24^^^500^^^mullet.jpg",
        "Tilapia^^^24^^^450^^^tilapia.jpg",
        "Dennis^^^27^^^400^^^dennis.jpg",
        "Levrek^^^35^^^250^^^levrek.jpg",
        "Red Tilapia^^^40^^^700^^^red_tilapia.jpg",
        "Pink Trout^^^46^^^450^^^pink_trout.jpg",
        "Barramundi^^^46^^^550^^^barramundi.png",
        "Basa Catfish^^^47^^^700^^^basa_catfish.jpeg",
        "Amberjack^^^48^^^400^^^amberjack.jpg",
        "Mackerel^^^48^^^400^^^mackerel.png",
        "Meagre^^^52^^^600^^^meagre.jpg",
        "Grouper^^^75^^^500^^^grouper.png",
        "Red Mullet^^^80^^^500^^^red_mullet.jpg",
        "Carp^^^80^^^2000^^^carp.jpg"
      ];

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
