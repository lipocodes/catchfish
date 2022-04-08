part of 'lobby_bloc.dart';

abstract class LobbyState extends Equatable {
  const LobbyState();

  @override
  List<Object> get props => [];
}

class LobbyInitial extends LobbyState {}

class EnteringLobbyState extends LobbyState {
  final bool hasRotatedTodayYet;
  const EnteringLobbyState({required this.hasRotatedTodayYet}) : super();
}

class LeavingLobbyState extends LobbyState {}

class RotateCompassState extends LobbyState {}

class EnteringDailyPrizeState extends LobbyState {
  const EnteringDailyPrizeState() : super();
}

class EndRotateCompassState extends LobbyState {}
