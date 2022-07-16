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

class LoadingPersonalCollectionEvent extends FishingEvent {
  final FishingUsecase fishingUsecase;
  final String email;
  const LoadingPersonalCollectionEvent(
      {required this.fishingUsecase, required this.email});
}

class SearchOtherPlayersEvent extends FishingEvent {
  final String name;
  const SearchOtherPlayersEvent({required this.name});
}

class GameOverEvent extends FishingEvent {}

class StartGameEvent extends FishingEvent {}

// ignore: must_be_immutable
class RejectPriceOfferEvent extends FishingEvent {
  late int index;
  final FishingUsecase fishingUsecase;
  RejectPriceOfferEvent({required this.index, required this.fishingUsecase});
}

// ignore: must_be_immutable
class AcceptPriceOfferEvent extends FishingEvent {
  late int index;
  final FishingUsecase fishingUsecase;
  AcceptPriceOfferEvent({required this.index, required this.fishingUsecase});
}

// ignore: must_be_immutable
class MoveItemToPersonalEvent extends FishingEvent {
  late int index;
  final FishingUsecase fishingUsecase;
  MoveItemToPersonalEvent({required this.index, required this.fishingUsecase});
}
