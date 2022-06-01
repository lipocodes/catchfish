import 'package:bloc/bloc.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/injection_container.dart';
import 'package:equatable/equatable.dart';

part 'fishing_event.dart';
part 'fishing_state.dart';

class FishingBloc extends Bloc<FishingEvent, FishingState> {
  FishingBloc() : super(FishingInitial()) {
    on<FishingEvent>((event, emit) {
      if (event is GetPulseEvent) {
        //sl.get<FishingUsecase>().getPulse()
        final res = sl.get<FishingUsecase>().getPulse();
        res.fold(
          (failure) => emit(const ErrorGetPulseState(
              message: "Error in getting a new pulse!")),
          (pulseEntity) =>
              emit(GetPulseState(pulseLength: 1.0, pulseStrength: 0.1)),
        );
      }
    });
  }
}
