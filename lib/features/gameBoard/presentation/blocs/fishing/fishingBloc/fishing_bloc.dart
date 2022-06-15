import 'package:bloc/bloc.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/local_datasource.dart';
import 'package:catchfish/features/gameBoard/data/datasources/fishing/remote_datasource.dart';
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

        res.fold(
          (failure) => emit(const ErrorRedButtonPressedState(
              message: "Error in dealing wuth red button press!")),
          (success) => emit(RedButtonPressedState(
              isFishCaught: sl.get<CaughtFishEntity>().isFishCaught,
              caughtFishDetails: sl.get<CaughtFishEntity>().caughtFishDetails)),
        );
      } else if (event is TimerTickEvent) {
        String currentCountdownTime = event.currentCountdownTime;
        _fishingUsecase = event.fishingUsecase;
        final res = await _fishingUsecase
            .calculateNewCoundownTime(currentCountdownTime);

        res.fold(
          (failure) => emit(const ErrorRedButtonPressedState(
              message: "Error in dealing with countdown tick!")),
          (success) => emit(TimerTickState(newCountdownTime: success)),
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
      }
    });
  }
}
