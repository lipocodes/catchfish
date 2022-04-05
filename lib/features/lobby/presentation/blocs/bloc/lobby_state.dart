part of 'lobby_bloc.dart';

abstract class LobbyState extends Equatable {
  const LobbyState();

  @override
  List<Object> get props => [];
}

class LobbyInitial extends LobbyState {}

class EnteringLobbyState extends LobbyState {
  const EnteringLobbyState() : super();
}

class LeavingLobbyState extends LobbyState {}
