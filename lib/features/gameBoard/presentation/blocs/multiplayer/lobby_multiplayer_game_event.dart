part of 'lobby_multiplayer_game_bloc.dart';

abstract class LobbyMultiplayerGameEvent extends Equatable {
  const LobbyMultiplayerGameEvent();

  @override
  List<Object> get props => [];
}

class JoinMultipleplayerGameEvent extends LobbyMultiplayerGameEvent {}

class QuitMultipleplayerGameEvent extends LobbyMultiplayerGameEvent {}

class GetUpdateMultipleplayerGameEvent extends LobbyMultiplayerGameEvent {}

class NeutralEvent extends LobbyMultiplayerGameEvent {}
