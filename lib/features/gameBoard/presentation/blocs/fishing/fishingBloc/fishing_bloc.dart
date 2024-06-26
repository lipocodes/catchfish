import 'package:bloc/bloc.dart';
import 'package:catchfish/core/errors/failures.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
import 'package:catchfish/features/gameBoard/data/repositories/fishing_repository_impl.dart';
import 'package:catchfish/features/gameBoard/domain/entities/fishing/caught_fish_entity.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/injection_container.dart';
import 'package:equatable/equatable.dart';

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
      } else if (event is LoadingPersonalCollectionEvent) {
        RemoteDatasource remoteDatasource = RemoteDatasource();
        LocalDatasourcePrefs localDatasourcePrefs = LocalDatasourcePrefs();
        _fishingUsecase = event.fishingUsecase;
        final res = await _fishingUsecase.populatePersonalCollection(
            remoteDatasource, localDatasourcePrefs, event.email);
        res.fold(
          (failure) => emit(const ErrorRedButtonPressedState(
              message: "Error in populating Personal Shop!")),
          (success) => emit(LoadingPersonalCollectionState(
              personalCollectionInventory: success, email: event.email)),
        );
      } else if (event is MoveItemToPersonalEvent) {
        _fishingUsecase = event.fishingUsecase;
        final res = await _fishingUsecase.moveToPersonalCollection(
            event.index, _fishingUsecase);
        res.fold(
          (failure) => emit(const ErrorRedButtonPressedState(
              message: "Error in moving item to personal collection!")),
          (success) =>
              emit(const MoveItemToPersonalCollectionState(success: true)),
        );
      } else if (event is SearchOtherPlayersEvent) {
        String name = event.name;

        final res = await _fishingUsecase.searchOtherPlayers(name);
        res.fold(
          (failure) => emit(const ErrorRedButtonPressedState(
              message: "Error in searching other players!")),
          (success) => emit(SearchOtherPlayersState(relevantPlayers: success)),
        );
      } else if (event is SendPriceOfferCollectionFishEvent) {
        String emailBuyer = event.emailBuyer;
        String price = event.price;
        String emailSeller = event.emailSeller;
        int indexFish = event.indexFish;
        _fishingUsecase = event.fishingUsecase;
        final res = await _fishingUsecase.sendPriceOfferCollectionFishEvent(
            emailBuyer, price, emailSeller, indexFish, _fishingUsecase);
        res.fold(
          (failure) => emit(const ErrorRedButtonPressedState(
              message: "Error in offer for personal collection fish")),
          (success) =>
              emit(SendPriceOfferCollectionFishState(success: success)),
        );
      } else if (event is AcceptPriceOfferCollectionFishEvent) {
        String emailBuyer = event.emailBuyer;
        String price = event.price;
        int indexFish = event.indexFish;
        _fishingUsecase = event.fishingUsecase;
        final res = await _fishingUsecase.acceptPriceOfferCollectionFish(
            emailBuyer, price, indexFish, _fishingUsecase);
        res.fold(
          (failure) => emit(const ErrorRedButtonPressedState(
              message: "Error in AcceptPriceOfferCollectionFishEvent")),
          (success) =>
              emit(AcceptPriceOfferCollectionFishState(success: success)),
        );
      } else if (event is ChangeShowCollectionEvent) {
        _fishingUsecase = event.fishingUsecase;
        await _fishingUsecase.changeShowCollection(event.show);
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
