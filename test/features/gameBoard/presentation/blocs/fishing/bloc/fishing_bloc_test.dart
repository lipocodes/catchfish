import 'dart:math';

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
import 'package:shared_preferences/shared_preferences.dart';
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
      //running the code of getPulse()
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int myLevel = prefs.getInt("myLevel") ?? 1;
      int random = Random().nextInt(10);
      double pulseStrength = (myLevel * random).toDouble();
      double pulseLength = 0.0;
      if (random == 10) {
        pulseLength = 2 - myLevel * 0.1;
      } else {
        pulseLength = random / 10;
      }
      //when(mockFishingUsecase.getPulse()).thenReturn(Left(GeneralFailure()));
      when(mockFishingUsecase.getPulse()).thenAnswer((_) async => Right(
          PulseEntity(pulseStrength: pulseStrength, pulseLength: pulseLength)));
      //creating a new event for fishingBloc
      fishingBloc.add(GetPulseEvent(fishingUsecase: mockFishingUsecase));
      //because fishingBloc runs getPulse() and emits a state accordingly
      expectLater(
          fishingBloc.stream,
          emitsInOrder([
            GetPulseState(
                pulseLength: pulseStrength, pulseStrength: pulseLength)
          ]));
      //expectLater(fishingBloc.stream,
      //  emitsInOrder([const ErrorGetPulseState(message: "")]));
    });
  });
}
