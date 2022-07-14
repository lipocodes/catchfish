part of 'lobby_bloc.dart';

abstract class LobbyState extends Equatable {
  const LobbyState();

  @override
  List<Object> get props => [];
}

class LobbyInitial extends LobbyState {}

class EnteringLobbyState extends LobbyState {
  final bool hasRotatedTodayYet;
  final int inventoryMoney;
  final int inventoryBaits;
  final int inventoryXP;
  final bool isLoggedIn;
  const EnteringLobbyState(
      {required this.hasRotatedTodayYet,
      required this.inventoryMoney,
      required this.inventoryBaits,
      required this.inventoryXP,
      required this.isLoggedIn})
      : super();
}

class ReturningLobbyState extends LobbyState {
  final bool hasRotatedTodayYet;
  final int inventoryMoney;
  final int inventoryBaits;
  final int inventoryXP;
  final int playerLevel;
  const ReturningLobbyState(
      {required this.hasRotatedTodayYet,
      required this.inventoryMoney,
      required this.inventoryBaits,
      required this.inventoryXP,
      required this.playerLevel});
}

class LeavingLobbyState extends LobbyState {}

class RotateCompassState extends LobbyState {}

class EnteringDailyPrizeState extends LobbyState {
  const EnteringDailyPrizeState() : super();
}

class EndRotateCompassState extends LobbyState {
  final String dailyPrize;
  final int inventoryMoney;
  final int inventoryBaits;
  final int inventoryXP;
  final bool isLoggedIn;
  const EndRotateCompassState(
      {required this.dailyPrize,
      required this.inventoryMoney,
      required this.inventoryBaits,
      required this.inventoryXP,
      required this.isLoggedIn});
}
