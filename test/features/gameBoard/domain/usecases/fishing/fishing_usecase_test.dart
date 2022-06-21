import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;
import 'package:mockito/mockito.dart';

import 'fishing_usecase_test.mocks.dart';

@GenerateMocks([FishingRepositoryImpl])
void main() {
  MockFishingRepositoryImpl mockFishingRepositoryImpl;
  FishingUsecase fishingUsecase = FishingUsecase();
  setUp(() async {});
  tearDown(() {});

  group("Testing FishingUsecase", () {
    di.init();

    test('testing getGameResults', () async {
      mockFishingRepositoryImpl = MockFishingRepositoryImpl();
      List<String> listAcheivements = ["Lior^^^100", "Eli^^^80", "Abed^^^60"];
      when(mockFishingRepositoryImpl.getGameResults())
          .thenAnswer((_) async => Right(listAcheivements));
      final res =
          await fishingUsecase.getGameResults(mockFishingRepositoryImpl);
      expectLater(res, Right(listAcheivements));
    });
  });
}
