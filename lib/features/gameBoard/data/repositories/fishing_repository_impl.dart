import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/domain/repositories/fishing/fishing_repository.dart';
import 'package:catchfish/features/settings/data/datasources/remote_datasource.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';

class FishingRepositoryImpl implements FishingRepository {
  @override
  Future<Either<Failure, int>> getLevelPref() async {
    final res = await sl.get<LocalDatasourcePrefs>().getLevelPref();
    if (res.isLeft()) {
      return Left(GeneralFailure());
    } else {
      return res;
    }
  }
}
