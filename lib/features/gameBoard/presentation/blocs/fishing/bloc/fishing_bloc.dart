import 'package:bloc/bloc.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/injection_container.dart';
import 'package:equatable/equatable.dart';

part 'fishing_event.dart';
part 'fishing_state.dart';

class FishingBloc extends Bloc<FishingEvent, FishingState> {
  late FishingUsecase _fishingUsecase;
  FishingBloc() : super(FishingInitial()) {
    on<FishingEvent>((event, emit) async {
      if (event is GetPulseEvent) {
        //sl.get<FishingUsecase>().getPulse()
        _fishingUsecase = event.fishingUsecase;
        final res = await _fishingUsecase.getPulse();
        res.fold(
          (failure) => emit(const ErrorGetPulseState(
              message: "Error in getting a new pulse!")),
          (pulseEntity) => emit(GetPulseState(
              pulseLength: pulseEntity.pulseLength,
              pulseStrength: pulseEntity.pulseStrength)),
        );
      } else if (event is BetweenPulsesEvent) {
        emit(BetweenPulsesState());
      } else if (event is RedButtonPressedEvent) {
        final res = await _fishingUsecase.isFishCaught();
        res.fold(
          (failure) => emit(const ErrorRedButtonPressedState(
              message: "Error in dealing wuth red button press!")),
          (success) => emit(RedButtonPressedState(isFishCaught: success)),
        );
        bool isFishCaught = true;
        emit(RedButtonPressedState(isFishCaught: isFishCaught));
      }
    });
  }
}
