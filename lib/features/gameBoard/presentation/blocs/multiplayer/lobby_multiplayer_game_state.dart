part of 'lobby_multiplayer_game_bloc.dart';

abstract class LobbyMultiplayerGameState extends Equatable {
  const LobbyMultiplayerGameState();

  @override
  List<Object> get props => [];
}

class LobbyMultiplayerGameInitial extends LobbyMultiplayerGameState {}

class JoinMultipleplayerGameState extends LobbyMultiplayerGameState {
  final bool successful;
  const JoinMultipleplayerGameState({required this.successful});
}

class QuitMultipleplayerGameState extends LobbyMultiplayerGameState {
  final bool successful;
  const QuitMultipleplayerGameState({required this.successful});
}

class GetUpdateMultipleplayerGameState extends LobbyMultiplayerGameState {
  final int timeTillStartGame;
  final List playersInGroup;
  const GetUpdateMultipleplayerGameState(
      {required this.timeTillStartGame, required this.playersInGroup});
}
