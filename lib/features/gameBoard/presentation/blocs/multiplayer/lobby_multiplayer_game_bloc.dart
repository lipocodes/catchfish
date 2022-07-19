import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lobby_multiplayer_game_event.dart';
part 'lobby_multiplayer_game_state.dart';

class LobbyMultiplayerGameBloc
    extends Bloc<LobbyMultiplayerGameEvent, LobbyMultiplayerGameState> {
  LobbyMultiplayerGameBloc() : super(LobbyMultiplayerGameInitial()) {
    on<LobbyMultiplayerGameEvent>((event, emit) {
      if (event is JoinMultipleplayerGameEvent) {
        emit(const JoinMultipleplayerGameState(successful: true));
      } else if (event is GetUpdateMultipleplayerGameEvent) {
        int timeTillStartGame = 100;
        List playersInGroup = [
          "https://th.bing.com/th/id/R.a875ddef4d39112e8371e8fdddf67157?rik=vEB9417RjaUz%2fw&pid=ImgRaw&r=0^^^Eli Shemesh"
        ];
        emit(GetUpdateMultipleplayerGameState(
            timeTillStartGame: timeTillStartGame,
            playersInGroup: playersInGroup));
      } else if (event is QuitMultipleplayerGameEvent) {
        emit(const QuitMultipleplayerGameState(successful: true));
      }
    });
  }
}
