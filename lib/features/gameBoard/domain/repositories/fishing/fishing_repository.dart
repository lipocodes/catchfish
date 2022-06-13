import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../data/datasources/fishing/remote_datasource.dart';

//shouyld be tested by Mockito
abstract class FishingRepository {
  Future<Either<Failure, bool>> updateLevel(
      int newLevel,
      LocalDatasourcePrefs localDatasourcePrefs,
      RemoteDatasource remoteDatasource);
}
