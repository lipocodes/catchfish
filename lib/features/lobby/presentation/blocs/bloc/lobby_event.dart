part of 'lobby_bloc.dart';

abstract class LobbyEvent extends Equatable {
  const LobbyEvent();

  @override
  List<Object> get props => [];
}

class EnteringLobbyEvent extends LobbyEvent {
  const EnteringLobbyEvent() : super();
}

class LeavingLobbyEvent extends LobbyEvent {}

class EnteringDailyPrizeEvent extends LobbyEvent {}

class RotateCompassEvent extends LobbyEvent {}

class EndRotateCompassEvent extends LobbyEvent {
  final double generatedNumber;
  const EndRotateCompassEvent({required this.generatedNumber});
}
