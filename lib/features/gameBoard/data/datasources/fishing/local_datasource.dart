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
}
