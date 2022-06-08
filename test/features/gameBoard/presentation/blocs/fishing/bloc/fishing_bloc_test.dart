import 'dart:math';

import 'package:catchfish/features/gameBoard/domain/entities/fishing/caught_fish_entity.dart';
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

// in console: dart run build_runner build, in order to create mock file for the classes mentioned in @GenerateMocks
@GenerateMocks(
    [FishingBloc, FishingUsecase]) //CMD:   dart run build_runner build
void main() {
  late MockFishingUsecase mockFishingUsecase;
  late FishingBloc fishingBloc;
  late CaughtFishEntity caughtFishEntity;

  tearDown(() {});

  group("Testing BLOC FishingBloc", () {
    di.init();
    fishingBloc = sl.get<FishingBloc>();
    caughtFishEntity = sl.get<CaughtFishEntity>();
    mockFishingUsecase = MockFishingUsecase();
    sl.registerLazySingleton<MockFishingUsecase>(() => MockFishingUsecase());
    test('testing GetPulseEvent', () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int myLevel = prefs.getInt("myLevel") ?? 1;
      int random = 1 + Random().nextInt(10);
      double pulseStrength = (myLevel * random).toDouble();
      double pulseLength = 0.0;

      if (random == 10) {
        pulseLength = 2 - myLevel * 0.1;
      } else {
        pulseLength = random / 10;
      }
      //when(mockFishingUsecase.getPulse()).thenReturn(Left(GeneralFailure()));
      when(mockFishingUsecase.getPulse()).thenAnswer((_) async => Right(
          PulseEntity(
              pulseStrength: pulseStrength,
              pulseLength: pulseLength,
              angle: 0.0)));
      //creating a new event for fishingBloc
      fishingBloc.add(GetPulseEvent(fishingUsecase: mockFishingUsecase));
      //because fishingBloc runs getPulse() and emits a state accordingly
      expectLater(
          fishingBloc.stream,
          emitsInOrder([
            GetPulseState(
              pulseLength: pulseStrength,
              pulseStrength: pulseLength,
              angle: 0.0,
            )
          ]));

      //expectLater(fishingBloc.stream,
      //  emitsInOrder([const ErrorGetPulseState(message: "")]));
    });

    //////////////////////////////////////////////////////////////////////
    test('testing BetweenPulseEvent', () {
      fishingBloc.add(BetweenPulsesEvent());
      expectLater(fishingBloc.stream, emitsInOrder([BetweenPulsesState()]));
    });
    /////////////////////////////////////////////////////////////////////

    test('testing RedButtonPressedEvent', () {
      when(mockFishingUsecase.isFishCaught())
          .thenAnswer((_) async => Right(caughtFishEntity));
      fishingBloc
          .add(RedButtonPressedEvent(fishingUsecase: mockFishingUsecase));
      expectLater(
          fishingBloc.stream,
          emitsInOrder([
            const RedButtonPressedState(
                isFishCaught: true, caughtFishDetails: "blad")
          ]));
    });
    ////////////////////////////////////////////////////////////////////////
    test('testing CountdownTickEvent', () {
      String currentCountdownTime = "05:00";
      when(mockFishingUsecase.calculateNewCoundownTime(
              mockFishingUsecase, currentCountdownTime))
          .thenAnswer((_) async => const Right("04:59"));
      fishingBloc.add(TimerTickEvent(
          fishingUsecase: mockFishingUsecase,
          currentCountdownTime: currentCountdownTime));
      expectLater(fishingBloc.stream,
          emitsInOrder([const TimerTickState(newCountdownTime: "04:59")]));
    });
    ///////////////////////////////////////////////////////////////////////////
    test('testing LoadingPersonalShopEvent', () {
      when(mockFishingUsecase.populatePersonalShop())
          .thenAnswer((_) async => const Right([]));
      fishingBloc.add(LoadingPersonalShopEvent(
        fishingUsecase: mockFishingUsecase,
      ));
      expectLater(
          fishingBloc.stream,
          emitsInOrder(
              [const LoadingPersonalShopState(personalShopInventory: [])]));
    });
  });
}
///////////////////////////////////////////////////////////////////////////////////