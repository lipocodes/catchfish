import 'package:catchfish/features/gameBoard/data/datasources/navigation/navigation_local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/navigation/navigation_remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/repositories/navigation_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/navigation/navigation_usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catchfish/injection_container.dart' as di;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'navigation_usecases_test.mocks.dart';

@GenerateMocks([NavigationRepositoryImpl])
void main() {
  MockNavigationRepositoryImpl mockNavigationRepositoryImpl;
  NavigationUsecases navigationUsecases = NavigationUsecases();
  NavigationLocalDatasource navigationLocalDatasource =
      NavigationLocalDatasource();
  NavigationRemoteDatasource navigationRemoteDatasource =
      NavigationRemoteDatasource();
  setUp(() async {});
  tearDown(() {});

  group("Testing NavigationUsecase", () {
    di.init();

    test('testing givePrizeNavigation', () async {
      mockNavigationRepositoryImpl = MockNavigationRepositoryImpl();
      when(mockNavigationRepositoryImpl.givePrizeNavigation(
              navigationLocalDatasource, navigationRemoteDatasource))
          .thenAnswer((_) async => const Right(true));
      final res = await navigationUsecases
          .givePrizeNavigation(mockNavigationRepositoryImpl);
      expectLater(res, const Right(true));
    });
  });
}
