import 'package:catchfish/core/consts/daily_prizes.dart';
import 'package:catchfish/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationLocalDatasource {
  Future<Either<GeneralFailure, bool>> givePrizeNavigation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int inventoryMoney = prefs.getInt("inventoryMoney") ?? 0;
      inventoryMoney += prizeForSuccessfulNavigation;
      prefs.setInt("inventoryMoney", inventoryMoney);
      return (const Right(true));
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
