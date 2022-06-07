import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:catchfish/injection_container.dart' as di;

@GenerateMocks([])
void main() {
  late FishingUsecase fishingUsecase;
  late String currentCountdownTime;
  setUp(() async {});
  tearDown(() {});

  group("Testing FishingUsecase", () {
    setUp(() async {
      await di.init();
      fishingUsecase = sl.get<FishingUsecase>();
      currentCountdownTime = "05:00";
    });

    test("testing calculateNewCoundownTime()", () async {
      final res = await fishingUsecase.calculateNewCoundownTime(
          fishingUsecase, currentCountdownTime);
      expectLater(res, const Right("04:59^^^5"));
    });
  });

  test('testing isFishCaught(', () async {
    await fishingUsecase.isFishCaught();
  });
}
