import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;
import 'package:mockito/mockito.dart';

import 'fishing_repository_impl_test.mocks.dart';

@GenerateMocks([LocalDatasourcePrefs, RemoteDatasource])
void main() {
  di.init();
  FishingRepositoryImpl fishingRepositoryImpl;
  MockLocalDatasourcePrefs mockLocalDatasourcePrefs;
  MockRemoteDatasource mockRemoteDatasource;

  setUp(() async {});
  tearDown(() {});
  group("Testing FishingRepositoryImpl", () {
    test("updateLevel()", () async {
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
    test("getLevelPref()", () async {
      mockLocalDatasourcePrefs = MockLocalDatasourcePrefs();
      mockRemoteDatasource = MockRemoteDatasource();
      fishingRepositoryImpl = sl.get<FishingRepositoryImpl>();
      when(mockLocalDatasourcePrefs.getLevelPref())
          .thenAnswer((_) async => const Right(1));
      when(mockRemoteDatasource.getLevelPlayer())
          .thenAnswer((_) async => const Right(1));
      final res = await fishingRepositoryImpl.getLevelPref(
          mockLocalDatasourcePrefs, mockRemoteDatasource);
      expectLater(res, const Right(1));
    });

    test("getPersonalShop()", () async {
      mockLocalDatasourcePrefs = MockLocalDatasourcePrefs();
      mockRemoteDatasource = MockRemoteDatasource();
      fishingRepositoryImpl = sl.get<FishingRepositoryImpl>();
      when(mockLocalDatasourcePrefs.getPersonalShopPref())
          .thenAnswer((_) async => const Right([]));
      when(mockRemoteDatasource.getPersonalShop())
          .thenAnswer((_) async => const Right([]));
      final res = await fishingRepositoryImpl.getPersonalShop(
          mockLocalDatasourcePrefs, mockRemoteDatasource);
      expectLater(res, const Right([]));
    });
    test("addFishPersonalShop()", () async {
      mockLocalDatasourcePrefs = MockLocalDatasourcePrefs();
      mockRemoteDatasource = MockRemoteDatasource();
      fishingRepositoryImpl = sl.get<FishingRepositoryImpl>();
      when(mockLocalDatasourcePrefs
              .addFishPersonalShop("Sargo^^^10^^^100^^^sargo.jpg"))
          .thenAnswer((_) async => const Right(true));
      when(mockRemoteDatasource
              .addFishPersonalShop("Sargo^^^10^^^100^^^sargo.jpg"))
          .thenAnswer((_) async => const Right(true));
      final res = await fishingRepositoryImpl.addFishPersonalShop(
        "Sargo^^^10^^^100^^^sargo.jpg",
      );
      expectLater(res, const Right(true));
    });
    test("removeFishPersonalShop()", () async {
      mockLocalDatasourcePrefs = MockLocalDatasourcePrefs();
      mockRemoteDatasource = MockRemoteDatasource();
      fishingRepositoryImpl = sl.get<FishingRepositoryImpl>();
      when(mockLocalDatasourcePrefs
              .removeFishPersonalShop("Sargo^^^10^^^100^^^sargo.jpg"))
          .thenAnswer((_) async => const Right(true));
      when(mockRemoteDatasource
              .removeFishPersonalShop("Sargo^^^10^^^100^^^sargo.jpg"))
          .thenAnswer((_) async => const Right(true));
      final res = await fishingRepositoryImpl.removeFishPersonalShop(
          "Sargo^^^10^^^100^^^sargo.jpg",
          mockLocalDatasourcePrefs,
          mockRemoteDatasource);
      expectLater(res, const Right(true));
    });
    test("deletegGroup()", () async {
      mockLocalDatasourcePrefs = MockLocalDatasourcePrefs();
      mockRemoteDatasource = MockRemoteDatasource();
      fishingRepositoryImpl = sl.get<FishingRepositoryImpl>();
      when(mockRemoteDatasource.deleteGroup("Group1"))
          .thenAnswer((_) async => const Right(true));
      final res = await fishingRepositoryImpl.deleteGroup(
          "Group1", mockRemoteDatasource);
      expectLater(res, const Right(true));
    });
    test("addPlayerToGroup()", () async {
      mockRemoteDatasource = MockRemoteDatasource();
      fishingRepositoryImpl = sl.get<FishingRepositoryImpl>();
      when(mockRemoteDatasource.addPlayerToGroup("Group1"))
          .thenAnswer((_) async => const Right(true));
      final res = await fishingRepositoryImpl.addPlayerToGroup(
          "Group1", mockRemoteDatasource);
      expectLater(res, const Right(true));
    });
    test("getPlayersForSelectedGroup()", () async {
      mockRemoteDatasource = MockRemoteDatasource();
      fishingRepositoryImpl = sl.get<FishingRepositoryImpl>();
      when(mockRemoteDatasource.getPlayersForSelectedGroup("Group1"))
          .thenAnswer((_) async => const Right([]));
      final res = await fishingRepositoryImpl.getPlayersForSelectedGroup(
          "Group1", mockRemoteDatasource);

      expectLater(res, const Right([]));
    });
    test("getExistingGroups()", () async {
      mockRemoteDatasource = MockRemoteDatasource();
      fishingRepositoryImpl = sl.get<FishingRepositoryImpl>();
      when(mockRemoteDatasource.getExistingGroups())
          .thenAnswer((_) async => const Right([]));
      final res =
          await fishingRepositoryImpl.getExistingGroups(mockRemoteDatasource);

      expectLater(res, const Right([]));
    });
  });

  test("addFishPersonalShop()", () async {
    /* WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    mockRemoteDatasource = MockRemoteDatasource();
    fishingRepositoryImpl = sl.get<FishingRepositoryImpl>();
    when(mockRemoteDatasource
            .addFishPersonalShop("Mullet^^^24^^^500^^^mullet.jpg"))
        .thenAnswer((realInvocation) async => const Right(true));
    final res = await fishingRepositoryImpl
        .addFishPersonalShop("Mullet^^^24^^^500^^^mullet.jpg");
    expectLater(res, const Right(true));*/
  });

  test(" getGameResults()", () async {
    List<String> listAcheivements = ["Lior^^^100", "Eli^^^80", "Abed^^^60"];
    mockRemoteDatasource = MockRemoteDatasource();
    when(mockRemoteDatasource.getExistingGroups())
        .thenAnswer((_) async => Right(listAcheivements));
    final res = await sl.get<FishingRepositoryImpl>().getGameResults();

    expectLater(res, Right(listAcheivements));
  });
}
