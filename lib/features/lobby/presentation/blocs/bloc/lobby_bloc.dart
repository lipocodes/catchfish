import 'package:bloc/bloc.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  late PlaySound playSound;
  LobbyBloc() : super(LobbyInitial()) {
    on<LobbyEvent>((event, emit) async {
      if (event is EnteringLobbyEvent) {
        playSound = PlaySound();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        playSound.play(path: "assets/sounds/lobby/", fileName: "waves.mp3");
        int dayLastRotation = /*prefs.getInt("dayLastRotation") ??*/ 0;
        if (DateTime.now().day == dayLastRotation) {
          emit(const EnteringLobbyState(hasRotatedTodayYet: true));
        } else {
          emit(const EnteringLobbyState(hasRotatedTodayYet: false));
        }
      } else if (event is LeavingLobbyEvent) {
        playSound.stop();
        emit(LeavingLobbyState());
      } else if (event is RotateCompassEvent) {
        emit(RotateCompassState());
      } else if (event is EndRotateCompassEvent) {
        playSound = PlaySound();
        playSound.play(path: "assets/sounds/lobby/", fileName: "applause.mp3");
        emit(const EndRotateCompassState());
      }
    });
  }
}
