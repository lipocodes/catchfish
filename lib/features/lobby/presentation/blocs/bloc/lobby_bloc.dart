import 'package:bloc/bloc.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:catchfish/features/lobby/domain/entities/button_or_arrow.dart';
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
        print("pppppppppppppp");
        playSound.stop();
        emit(LeavingLobbyState());
      } else if (event is RotateCompassEvent) {
        emit(RotateCompassState());
      } else if (event is EnteringDailyPrizeEvent) {
        emit(const EnteringDailyPrizeState());
      }
    });
  }
}
