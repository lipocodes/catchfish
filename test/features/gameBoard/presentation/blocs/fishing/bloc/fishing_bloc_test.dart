import 'package:catchfish/features/gameBoard/domain/entities/fishing/pulse_entity.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/bloc/fishing_bloc.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'fishing_bloc_test.mocks.dart';
import 'package:catchfish/injection_container.dart' as di;

@GenerateMocks(
    [FishingBloc, FishingUsecase]) //CMD:   dart run build_runner build
void main() {
  late MockFishingUsecase mockFishingUsecase;

  setUp(() async {
    await di.init();

    mockFishingUsecase = MockFishingUsecase();
    sl.registerLazySingleton<MockFishingUsecase>(() => MockFishingUsecase());
  });

  tearDown(() {});

  group(
      "Tests validating that the BLOC call & received data from the relevant usecase",
      () {
    test('Verifying that BLOC is OK', () async {
      final fishingBloc = sl.get<FishingBloc>();
      mockFishingUsecase = sl.get<MockFishingUsecase>();
      when(mockFishingUsecase.getPulse()).thenReturn(Left(GeneralFailure()));
      fishingBloc.add(const GetPulseEvent());

      expectLater(fishingBloc.stream,
          emitsInOrder([GetPulseState(pulseLength: 1.0, pulseStrength: 0.1)]));
      //expectLater(fishingBloc.stream,emitsInOrder([const ErrorGetPulseState(message: "")]));
    });
  });
}
