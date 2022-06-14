part of 'fishing_bloc.dart';

abstract class FishingEvent extends Equatable {
  const FishingEvent();

  @override
  List<Object> get props => [];
}

class EnteringScreenEvent extends FishingEvent {
  final FishingUsecase fishingUsecase;
  const EnteringScreenEvent({required this.fishingUsecase});
}

class GetPulseEvent extends FishingEvent {
  final FishingUsecase fishingUsecase;
  const GetPulseEvent({required this.fishingUsecase});
}

class BetweenPulsesEvent extends FishingEvent {}

class RedButtonPressedEvent extends FishingEvent {
  final FishingUsecase fishingUsecase;
  const RedButtonPressedEvent({required this.fishingUsecase});
}

class TimerTickEvent extends FishingEvent {
  final FishingUsecase fishingUsecase;
  final String currentCountdownTime;

  const TimerTickEvent(
      {required this.fishingUsecase, required this.currentCountdownTime});
}

class AfterTimerTickEvent extends FishingEvent {}

class LoadingPersonalShopEvent extends FishingEvent {
  final FishingUsecase fishingUsecase;
  const LoadingPersonalShopEvent({required this.fishingUsecase});
}

class StartingGameEvent extends FishingEvent {
  final FishingUsecase fishingUsecase;
  const StartingGameEvent({required this.fishingUsecase});
}
