part of 'fishing_bloc.dart';

abstract class FishingState extends Equatable {
  const FishingState();

  @override
  List<Object> get props => [];
}

class FishingInitial extends FishingState {}

class EnteringScreenState extends FishingState {}

class GetPulseState extends FishingState {
  final double pulseStrength;
  final double pulseLength;
  final double angle;
  const GetPulseState(
      {required this.pulseStrength,
      required this.pulseLength,
      required this.angle});
}

class BetweenPulsesState extends FishingState {}

class ErrorGetPulseState extends FishingState {
  final String message;
  const ErrorGetPulseState({required this.message});
}

class RedButtonPressedState extends FishingState {
  final bool isFishCaught;
  final String caughtFishDetails;
  const RedButtonPressedState(
      {required this.isFishCaught, required this.caughtFishDetails});
}

class ErrorRedButtonPressedState extends FishingState {
  final String message;
  const ErrorRedButtonPressedState({required this.message});
}

class TimerTickState extends FishingState {
  final String newCountdownTime;
  final int numPlayers;
  final String groupLeader;
  final bool gameStarted;
  final String namePlayerCaughtFish;

  const TimerTickState({
    required this.newCountdownTime,
    required this.numPlayers,
    required this.groupLeader,
    required this.gameStarted,
    required this.namePlayerCaughtFish,
  });
}

class AfterTimerTickState extends FishingState {}

class LoadingPersonalShopState extends FishingState {
  final List<String> personalShopInventory;
  const LoadingPersonalShopState({required this.personalShopInventory});
}

class LoadingPersonalCollectionState extends FishingState {
  final List<String> personalCollectionInventory;
  const LoadingPersonalCollectionState(
      {required this.personalCollectionInventory});
}

class MoveItemToPersonalCollectionState extends FishingState {
  final bool success;
  const MoveItemToPersonalCollectionState({required this.success});
}

class GameOverState extends FishingState {
  //each member: player with his acheivements
  final List<String> listAcheivements;
  const GameOverState({required this.listAcheivements});
}

class StartGameState extends FishingState {}

class RejectPriceOfferState extends FishingState {
  List listItems = [];
  RejectPriceOfferState({required this.listItems});
}

class AcceptPriceOfferState extends FishingState {
  List listItems = [];
  AcceptPriceOfferState({required this.listItems});
}
