import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/navigation/navigation_local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/navigation/navigation_remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/repositories/navigation_repository_impl.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';

class NavigationUsecases {
  Future<Either<GeneralFailure, bool>> givePrizeNavigation(
      NavigationRepositoryImpl navigationRepositoryImpl) async {
    try {
      bool yesNo = false;
      final res = await navigationRepositoryImpl.givePrizeNavigation(
          sl.get<NavigationLocalDatasource>(),
          sl.get<NavigationRemoteDatasource>());
      res.fold((l) => GeneralFailure(), (r) => yesNo = r);
      return Right(yesNo);
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeee=" + e.toString());
      return Left(GeneralFailure());
    }
  }
}
