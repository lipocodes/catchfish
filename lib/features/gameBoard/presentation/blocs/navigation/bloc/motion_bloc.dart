import 'package:bloc/bloc.dart';
import 'package:catchfish/core/consts/marinas.dart';
import 'package:equatable/equatable.dart';

part 'motion_event.dart';
part 'motion_state.dart';

class MotionBloc extends Bloc<MotionEvent, MotionState> {
  /////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////
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
    print("cccccccccccccccc=" + numIntersections.toString());
    if (numIntersections % 2 == 0) {
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
        bool isLegalMove = checkPointInsidePolygon(event.yCoordinate - 0.0001,
            event.xCoordinate - 0.0001, event.indexMarina);
        if (isLegalMove &&
            event.statusGear != "N" &&
            event.isBoatRunning == true) {
          event.xCoordinate -= 0.0001;
          event.yCoordinate -= 0.0001;
        }

        emit(NewCoordinatesState(
            xCoordinate: event.xCoordinate, yCoordinate: event.yCoordinate));
      } else if (event is IdleEvent) {
        emit(IdleState());
      }
    });
  }
}
