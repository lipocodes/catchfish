import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
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
    di.init();
    fishingUsecase = sl.get<FishingUsecase>();
    currentCountdownTime = "05:00";

    test("testing calculateNewCoundownTime()", () async {
      final res = await fishingUsecase.calculateNewCoundownTime(
          fishingUsecase, currentCountdownTime);
      expectLater(res, const Right("04:59^^^5"));
    });
  });

  test('testing GetPulse()', () async {
    /*final res = await fishingUsecase.getPulse();
    expectLater(
        res,
        const Right(
            PulseEntity(pulseStrength: 1.0, pulseLength: 0.3, angle: 0)));*/
  });

  test('testing isFishCaught(', () async {
    final res = await fishingUsecase.isFishCaught();
  });

  test('testing populatePersonalShop(', () async {
    Either<Failure, List<String>> res =
        await fishingUsecase.populatePersonalShop();
    //expectLater(res, const Right(["Fat Fish^^^100^^^1000^^^fat_fish"]));
  });
}
