part of 'fishing_bloc.dart';

abstract class FishingEvent extends Equatable {
  const FishingEvent();

  @override
  List<Object> get props => [];
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
