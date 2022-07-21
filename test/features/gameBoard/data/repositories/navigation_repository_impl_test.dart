import 'package:catchfish/features/gameBoard/data/datasources/navigation/navigation_local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/navigation/navigation_remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/repositories/navigation_repository_impl.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;
import 'package:mockito/mockito.dart';

import 'navigation_repository_impl_test.mocks.dart';

@GenerateMocks([NavigationLocalDatasource, NavigationRemoteDatasource])
void main() {
  di.init();
  MockNavigationLocalDatasource mockNavigationLocalDatasource =
      MockNavigationLocalDatasource();
  MockNavigationRemoteDatasource mockNavigationRemoteDatasource =
      MockNavigationRemoteDatasource();

  setUp(() async {});
  tearDown(() {});
  group("Testing NavigationRepositoryImpl", () {
    test("givePrizeNavigation()", () async {
      when(mockNavigationLocalDatasource.givePrizeNavigation())
          .thenAnswer((_) async => const Right(true));

      final res = await sl.get<NavigationRepositoryImpl>().givePrizeNavigation(
          mockNavigationLocalDatasource, mockNavigationRemoteDatasource);

      expectLater(res, const Right(true));
    });
  });
}
