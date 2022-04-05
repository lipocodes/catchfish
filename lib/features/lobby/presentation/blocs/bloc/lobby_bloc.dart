import 'package:bloc/bloc.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:equatable/equatable.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  late PlaySound playSound;
  LobbyBloc() : super(LobbyInitial()) {
    on<LobbyEvent>((event, emit) {
      if (event is EnteringLobbyEvent) {
        playSound = PlaySound();
        playSound.play(path: "assets/sounds/lobby/", fileName: "waves.mp3");
        emit(const EnteringLobbyState());
      } else if (event is LeavingLobbyEvent) {
        playSound.stop();
        emit(LeavingLobbyState());
      }
    });
  }
}
