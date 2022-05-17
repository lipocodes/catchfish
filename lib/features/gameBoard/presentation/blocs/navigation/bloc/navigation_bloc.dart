import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:audioplayers/audioplayers.dart';
part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  late String statusGear = "N";
  double steeringAngle = 0.0;
  bool isBoatRunning = false;
  final AudioCache audioCache = AudioCache(prefix: "assets/sounds/gameBoard/");
  AudioPlayer audioPlayer1 = AudioPlayer();
  AudioPlayer audioPlayer2 = AudioPlayer();
  playBackgroundAudio(bool needIgnition, String engineSound) async {
    if (needIgnition) {
      audioPlayer1 = await audioCache.play("ignition.mp3");
    }

    audioPlayer2 = await audioCache.loop(engineSound);
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
        emit(
            ShowMapState(isBoatRunning: isBoatRunning, statusGear: statusGear));
      } else if (event is LeavingNavigationEvent) {
        stopBackgroundAudio();
        statusGear = "N";
        steeringAngle = 0.0;
        isBoatRunning = false;
        emit(LeavingNavigationState());
      } else if (event is SpinSteeringWheelEvent) {
        if (event.isClockwise && isBoatRunning) {
          steeringAngle += 0.03;
        } else if (isBoatRunning) {
          steeringAngle -= 0.03;
        }
        emit(SpinSteeringWheelState(
            steeringAngle: steeringAngle,
            isBoatRunning: isBoatRunning,
            statusGear: statusGear));
      } else if (event is IgnitionEvent) {
        if (isBoatRunning) {
          isBoatRunning = false;
          stopBackgroundAudio();
          emit(IgnitionState(isBoatRunning: false, statusGear: statusGear));
        } else {
          isBoatRunning = true;
          statusGear = "N";
          playBackgroundAudio(true, "N.mp3");
        }
        emit(IgnitionState(isBoatRunning: true, statusGear: statusGear));
      } else if (event is GearEvent) {
        if (event.selectedNewPosition == "F2" && statusGear == "F1") {
          statusGear = event.selectedNewPosition;
          stopBackgroundAudio();
          playBackgroundAudio(false, "F2.mp3");
        } else if (event.selectedNewPosition == "F1" &&
            (statusGear == "F2" || statusGear == "N")) {
          statusGear = event.selectedNewPosition;
          stopBackgroundAudio();
          playBackgroundAudio(false, "F1.mp3");
        } else if (event.selectedNewPosition == "N" &&
            (statusGear == "F1" || statusGear == "R")) {
          statusGear = event.selectedNewPosition;
          stopBackgroundAudio();
          playBackgroundAudio(false, "N.mp3");
        } else if (event.selectedNewPosition == "R" && statusGear == "N") {
          statusGear = event.selectedNewPosition;
          stopBackgroundAudio();
          playBackgroundAudio(false, "R.mp3");
        }
        emit(GearState(isBoatRunning: isBoatRunning, statusGear: statusGear));
      }
    });
  }
}
