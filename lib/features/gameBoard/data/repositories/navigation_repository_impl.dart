import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/navigation/navigation_local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/navigation/navigation_remote_datasource.dart';
import 'package:catchfish/features/gameBoard/domain/repositories/navigation/navigation_repository.dart';
import 'package:dartz/dartz.dart';

class NavigationRepositoryImpl extends NavigationRepository {
  Future<Either<GeneralFailure, bool>> givePrizeNavigation(
      NavigationLocalDatasource navigationLocalDatasource,
      NavigationRemoteDatasource navigationRemoteDatasource) async {
    try {
      bool yesNo = true;
      final res1 = await navigationLocalDatasource.givePrizeNavigation();
      final res2 = await navigationRemoteDatasource.givePrizeNavigation();
      res1.fold((l) => GeneralFailure(), (r) => yesNo = r);

      return Right(yesNo);
    } catch (e) {
      return Left(GeneralFailure());
    }
  }
}
