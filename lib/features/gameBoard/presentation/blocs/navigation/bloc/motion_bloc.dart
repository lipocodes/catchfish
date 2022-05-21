import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:catchfish/core/consts/marinas.dart';
import 'package:equatable/equatable.dart';

part 'motion_event.dart';
part 'motion_state.dart';

class MotionBloc extends Bloc<MotionEvent, MotionState> {
  final AudioCache audioCache = AudioCache(prefix: "assets/sounds/gameBoard/");
  AudioPlayer audioPlayer = AudioPlayer();

  playBackgroundAudio(String engineSound) async {
    audioPlayer = await audioCache.play(engineSound);
  }

  bool checkPointInsidePolygon(double x, double y, int indexMarina) {
    //Based on Ray Casting algorithm for checking if a point is inside a polygon

    int numIntersections = 0;
    List<String> list = polygonsMarinas[indexMarina];

    //taking every 2 adjacent vertices of the polygon
    for (int a = 0; a < list.length - 1; a++) {
      String temp1 = list[a];
      List<String> temp2 = temp1.split(",");
      //geting their coordinates
      double y1 = double.parse(temp2[0]);
      double x1 = double.parse(temp2[1]);
      temp1 = list[a + 1];
      temp2 = temp1.split(",");
      double y2 = double.parse(temp2[0]);
      double x2 = double.parse(temp2[1]);
      //checking if the ckecked point intesects with the edge run by (x1,y1) and (x2,y2)
      //condition 1: if longitudePoint is between y1,y2
      if (y < y1 == y < y2) {
        continue;
      }
      //condition 2: if we draw an horizontal line from our point to the edge run by (x1,y1) and (x2,y2),
      // is value x of this intersection bigger than value x of our point
      if (x >= ((x2 - x1) * (y - y1) / (y2 - y1) + x1)) {
        double temp = ((x2 - x1) * (x - y1) / (y2 - y1) + x1);

        continue;
      }
      numIntersections = numIntersections + 1;
    }

    if (numIntersections % 2 == 0) {
      playBackgroundAudio("spark.mp3");
      return false;
    } else {
      return true;
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////
  MotionBloc() : super(MotionInitial()) {
    on<MotionEvent>((event, emit) {
      if (event is NewCoordinatesEvent) {
        double standardUnit = 0.0001;
        int angleDegrees = (event.steeringAngle * 57.2957795).floor();

        int gapTo0 = 0;
        int gapTo90 = 0;
        int gapTo180 = 0;
        int gapTo270 = 0;

        double impactAxisX = 1;
        double impactAxisY = 1;
        if (angleDegrees < 90) {
          if (angleDegrees < 1) {
            gapTo0 = 1;
          } else {
            gapTo0 = angleDegrees;
          }
          impactAxisX = gapTo0 / 90;
          impactAxisY = (90 - gapTo0) / 90;
        } else if (angleDegrees < 180) {
          if (angleDegrees - 90 < 1) {
            gapTo90 = 1;
          } else {
            gapTo90 = angleDegrees - 90;
          }

          impactAxisX = (90 - gapTo90) / 90;
          impactAxisY = -(gapTo90 / 90);
        } else if (angleDegrees < 270) {
          if (angleDegrees - 180 < 1) {
            gapTo180 = 1;
          } else {
            gapTo180 = angleDegrees - 180;
          }
          impactAxisX = -(gapTo180 / 90);
          impactAxisY = -(90 - gapTo180) / 90;
        } else if (angleDegrees < 360) {
          if (angleDegrees - 270 < 1) {
            gapTo270 = 1;
          } else {
            gapTo270 = angleDegrees - 270;
          }

          impactAxisX = -(90 - gapTo270) / 90;
          impactAxisY = gapTo270 / 90;
        }
        ///////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////
        double coordinateChangeX = impactAxisY * standardUnit;
        double coordinateChangeY = impactAxisX * standardUnit;
        if (event.statusGear == "F2") {
          coordinateChangeX *= 2;
          coordinateChangeY *= 2;
        }

        bool isLegalMove = checkPointInsidePolygon(
            event.yCoordinate + coordinateChangeX,
            event.xCoordinate + coordinateChangeY,
            event.indexMarina);

        if (isLegalMove &&
            (event.statusGear == "F1" || event.statusGear == "F2") &&
            event.isBoatRunning == true) {
          event.xCoordinate += coordinateChangeX;
          event.yCoordinate += coordinateChangeY;
        } else if (isLegalMove &&
            event.statusGear == "R" &&
            event.isBoatRunning == true) {
          event.xCoordinate -= coordinateChangeX;
          event.yCoordinate -= coordinateChangeY;
        }

        emit(NewCoordinatesState(
            xCoordinate: event.xCoordinate, yCoordinate: event.yCoordinate));
      } else if (event is IdleEvent) {
        emit(IdleState());
      }
    });
  }
}
