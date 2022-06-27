import 'package:bloc/bloc.dart';
import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/caught_fish_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/injection_container.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'fishing_event.dart';
part 'fishing_state.dart';

class FishingBloc extends Bloc<FishingEvent, FishingState> {
  late FishingUsecase _fishingUsecase;
  FishingBloc() : super(FishingInitial()) {
    on<FishingEvent>((event, emit) async {
      if (event is EnteringScreenEvent) {
        _fishingUsecase = event.fishingUsecase;
        final res = await _fishingUsecase.playEnteringScreenSound();
        emit(EnteringScreenState());
      } else if (event is GetPulseEvent) {
        //sl.get<FishingUsecase>().getPulse()
        _fishingUsecase = event.fishingUsecase;
        final res = await _fishingUsecase.getPulse();
        res.fold(
          (failure) => emit(const ErrorGetPulseState(
              message: "Error in getting a new pulse!")),
          (pulseEntity) => emit(GetPulseState(
              pulseLength: pulseEntity.pulseLength,
              pulseStrength: pulseEntity.pulseStrength,
              angle: pulseEntity.angle)),
        );
      } else if (event is BetweenPulsesEvent) {
        emit(BetweenPulsesState());
      } else if (event is RedButtonPressedEvent) {
        final res = await event.fishingUsecase.isFishCaught();
        //if fish is caught: update the datasources about it
        if (res.isRight()) {
          sl.get<FishingUsecase>().updateCaughtInGroups(
              sl.get<CaughtFishEntity>().caughtFishDetails);
          sl.get<FishingUsecase>().addFishPersonalShop(
              sl.get<CaughtFishEntity>().caughtFishDetails);
        }
        res.fold(
          (failure) => emit(const ErrorRedButtonPressedState(
              message: "Error in dealing with red button press!")),
          (success) => emit(RedButtonPressedState(
              isFishCaught: sl.get<CaughtFishEntity>().isFishCaught,
              caughtFishDetails: sl.get<CaughtFishEntity>().caughtFishDetails)),
        );
      } else if (event is StartGameEvent) {
        await sl.get<FishingUsecase>().startGame();
        //emit(StartGameState());
      } else if (event is TimerTickEvent) {
        int numPlayers = 0;
        bool gameStarted = false;
        String groupName = "";
        final res0 = await sl.get<FishingUsecase>().hasGameStarted();
        res0.fold((l) => GeneralFailure(), (r) => gameStarted = r);

        final res1 = await _fishingUsecase.retreiveNumPlayers();
        res1.fold((l) => null, (r) => numPlayers = r);
        String currentCountdownTime = event.currentCountdownTime;
        _fishingUsecase = event.fishingUsecase;
        final res2 = await _fishingUsecase.getGroupLeader();
        res2.fold((l) => null, (r) => groupName = r);
        String namePlayerCaughtFish = "";
        final res3 = await _fishingUsecase.getNamePlayerCaughtFish();

        res3.fold((l) => GeneralFailure(), (r) => namePlayerCaughtFish = r);

        final res4 = await _fishingUsecase
            .calculateNewCoundownTime(currentCountdownTime);
        res4.fold(
          (failure) => emit(const ErrorRedButtonPressedState(
              message: "Error in dealing with countdown tick!")),
          (success) => emit(TimerTickState(
              newCountdownTime: success,
              numPlayers: numPlayers,
              gameStarted: gameStarted,
              groupLeader: groupName,
              namePlayerCaughtFish: namePlayerCaughtFish)),
        );
      } else if (event is AfterTimerTickEvent) {
        emit(AfterTimerTickState());
      } else if (event is LoadingPersonalShopEvent) {
        RemoteDatasource remoteDatasource = RemoteDatasource();
        LocalDatasourcePrefs localDatasourcePrefs = LocalDatasourcePrefs();
        _fishingUsecase = event.fishingUsecase;
        final res = await _fishingUsecase.populatePersonalShop(
            remoteDatasource, localDatasourcePrefs);

        res.fold(
          (failure) => emit(const ErrorRedButtonPressedState(
              message: "Error in populating Personal Shop!")),
          (success) =>
              emit(LoadingPersonalShopState(personalShopInventory: success)),
        );
      } else if (event is GameOverEvent) {
        List<String> listAcheivements = [];
        FishingRepositoryImpl fishingRepositoryImpl = FishingRepositoryImpl();
        final res = await sl
            .get<FishingUsecase>()
            .getGameResults(fishingRepositoryImpl);

        res.fold(
          (failure) => GeneralFailure(),
          (success) => listAcheivements = success,
        );
        emit(GameOverState(listAcheivements: listAcheivements));
      } else if (event is RejectPriceOfferEvent) {
        List listItems = [];
        int index = event.index;
        _fishingUsecase = event.fishingUsecase;
        FishingRepositoryImpl fishingRepositoryImpl = FishingRepositoryImpl();
        final res = await _fishingUsecase.rejectPriceOffer(
            index, fishingRepositoryImpl);
        res.fold((l) => GeneralFailure(), (r) => listItems = r);
        emit(RejectPriceOfferState(listItems: listItems));
      } else if (event is AcceptPriceOfferEvent) {
        List listItems = [];
        int index = event.index;
        _fishingUsecase = event.fishingUsecase;
        FishingRepositoryImpl fishingRepositoryImpl = FishingRepositoryImpl();
        final res = await _fishingUsecase.acceptPriceOffer(
            index, fishingRepositoryImpl);
        res.fold((l) => GeneralFailure(), (r) => listItems = r);
        emit(AcceptPriceOfferState(listItems: listItems));
      }
    });
  }
}
