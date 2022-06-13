import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;
import 'package:mockito/mockito.dart';

import 'fishing_repository_impl_test.mocks.dart';

@GenerateMocks([LocalDatasourcePrefs, RemoteDatasource])
void main() {
  FishingRepositoryImpl fishingRepositoryImpl;
  MockLocalDatasourcePrefs mockLocalDatasourcePrefs;
  MockRemoteDatasource mockRemoteDatasource;
  setUp(() async {});
  tearDown(() {});
  group("Testing FishingRepositoryImpl", () {
    test("updateLevel()", () async {
      di.init();
      mockLocalDatasourcePrefs = MockLocalDatasourcePrefs();
      mockRemoteDatasource = MockRemoteDatasource();
      fishingRepositoryImpl = sl.get<FishingRepositoryImpl>();
      when(mockLocalDatasourcePrefs.updateLevelPref(2))
          .thenAnswer((_) async => const Right(true));
      when(mockRemoteDatasource.updateLevelPlayer(2))
          .thenAnswer((_) async => const Right(true));
      final res = await fishingRepositoryImpl.updateLevel(
          2, mockLocalDatasourcePrefs, mockRemoteDatasource);
      expectLater(res, const Right(true));
    });
  });
}
