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
