import 'package:bloc/bloc.dart';
import 'package:catchfish/core/utils/play_sound.dart';
import 'package:equatable/equatable.dart';
import 'package:audioplayers/audioplayers.dart';
part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  double steeringAngle = 0.0;
  bool isBoatRunning = false;
  final AudioCache audioCache = AudioCache(prefix: "assets/sounds/gameBoard/");
  AudioPlayer audioPlayer1 = AudioPlayer();
  AudioPlayer audioPlayer2 = AudioPlayer();
  playBackgroundAudio() async {
    audioPlayer1 = await audioCache.play("ignition.mp3");
    audioPlayer2 = await audioCache.loop("engine.mp3");
  }

  stopBackgroundAudio() async {
    audioPlayer1.stop();
    audioPlayer2.stop();
  }

  NavigationBloc() : super(NavigationInitial()) {
    on<NavigationEvent>((event, emit) {
      if (event is EnteringNavigationEvent) {
        emit(EnteringNavigationState());
      } else if (event is ShowMapEvent) {
        emit(ShowMapState(isBoatRunning: isBoatRunning));
      } else if (event is LeavingNavigationEvent) {
        emit(LeavingNavigationState());
      } else if (event is SpinSteeringWheelEvent) {
        if (event.isClockwise && isBoatRunning) {
          steeringAngle += 0.04;
        } else if (isBoatRunning) {
          steeringAngle -= 0.04;
        }
        emit(SpinSteeringWheelState(
            steeringAngle: steeringAngle, isBoatRunning: isBoatRunning));
      } else if (event is IgnitionEvent) {
        if (isBoatRunning) {
          isBoatRunning = false;
          stopBackgroundAudio();
          emit(const IgnitionState(isBoatRunning: false));
        } else {
          isBoatRunning = true;
          playBackgroundAudio();
        }
        emit(const IgnitionState(isBoatRunning: true));
      }
    });
  }
}
