import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget boatSteering(BuildContext context, double steeringAngle) {
  double xLastMeasure = 0.0;
  double yLastMeasure = 0.0;
  double xStartQuarter1 = 181.0;
  double xEndQuarter1 = 310.0;
  double yStartQuarter1 = 24;
  double yEndQuarter1 = 158;
  double xStartQuarter2 = 181.0;
  double xEndQuarter2 = 310.0;
  double yStartQuarter2 = 158;
  double yEndQuarter2 = 280;
  double xStartQuarter3 = 63.0;
  double xEndQuarter3 = 180.0;
  double yStartQuarter3 = 158;
  double yEndQuarter3 = 280;
  double xStartQuarter4 = 63.0;
  double xEndQuarter4 = 180.0;
  double yStartQuarter4 = 24;
  double yEndQuarter4 = 158;

  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.4,
    //width: MediaQuery.of(context).size.width * 0.9,
    child: Transform.rotate(
      angle: steeringAngle,
      child: GestureDetector(
        onPanStart: (v) {
          xLastMeasure = v.localPosition.dx;
          yLastMeasure = v.localPosition.dy;
          BlocProvider.of<NavigationBloc>(context)
              .add(SpinSteeringWheelEvent(isClockwise: true));
        },
        onPanUpdate: (v) {
          if (v.localPosition.dx > xLastMeasure &&
              v.localPosition.dx > xStartQuarter1 &&
              v.localPosition.dx < xEndQuarter1 &&
              v.localPosition.dy > yStartQuarter1 &&
              v.localPosition.dy < yEndQuarter1) {
            print("Clockwise,1st quarter.");
            BlocProvider.of<NavigationBloc>(context)
                .add(SpinSteeringWheelEvent(isClockwise: true));
          } else if (v.localPosition.dx < xLastMeasure &&
              v.localPosition.dx > xStartQuarter2 &&
              v.localPosition.dx < xEndQuarter2 &&
              v.localPosition.dy > yStartQuarter2 &&
              v.localPosition.dy < yEndQuarter2) {
            print("Clockwise,2nd quarter.");
            BlocProvider.of<NavigationBloc>(context)
                .add(SpinSteeringWheelEvent(isClockwise: true));
          } else if (v.localPosition.dx < xLastMeasure &&
              v.localPosition.dx > xStartQuarter3 &&
              v.localPosition.dx < xEndQuarter3 &&
              v.localPosition.dy > yStartQuarter3 &&
              v.localPosition.dy < yEndQuarter3) {
            print("Clockwise,3rd quarter.");
            BlocProvider.of<NavigationBloc>(context)
                .add(SpinSteeringWheelEvent(isClockwise: true));
          } else if (v.localPosition.dx > xLastMeasure &&
              v.localPosition.dx > xStartQuarter4 &&
              v.localPosition.dx < xEndQuarter4 &&
              v.localPosition.dy > yStartQuarter4 &&
              v.localPosition.dy < yEndQuarter4) {
            print("Clockwise,4th quarter.");
            BlocProvider.of<NavigationBloc>(context)
                .add(SpinSteeringWheelEvent(isClockwise: true));
          } else if (v.localPosition.dx < xLastMeasure &&
              v.localPosition.dx > xStartQuarter4 &&
              v.localPosition.dx < xEndQuarter4 &&
              v.localPosition.dy > yStartQuarter4 &&
              v.localPosition.dy < yEndQuarter4) {
            print("Counter clockwise,4th quarter.");
            BlocProvider.of<NavigationBloc>(context)
                .add(SpinSteeringWheelEvent(isClockwise: false));
          } else if (v.localPosition.dx > xLastMeasure &&
              v.localPosition.dx > xStartQuarter3 &&
              v.localPosition.dx < xEndQuarter3 &&
              v.localPosition.dy > yStartQuarter3 &&
              v.localPosition.dy < yEndQuarter3) {
            print("Counter clockwise,3rd quarter.");
            BlocProvider.of<NavigationBloc>(context)
                .add(SpinSteeringWheelEvent(isClockwise: false));
          } else if (v.localPosition.dx > xLastMeasure &&
              v.localPosition.dx > xStartQuarter2 &&
              v.localPosition.dx < xEndQuarter2 &&
              v.localPosition.dy > yStartQuarter2 &&
              v.localPosition.dy < yEndQuarter2) {
            print("Counter clockwise,2nd quarter.");
            BlocProvider.of<NavigationBloc>(context)
                .add(SpinSteeringWheelEvent(isClockwise: false));
          } else if (v.localPosition.dx < xLastMeasure &&
              v.localPosition.dx > xStartQuarter1 &&
              v.localPosition.dx < xEndQuarter1 &&
              v.localPosition.dy > yStartQuarter1 &&
              v.localPosition.dy < yEndQuarter1) {
            print("Anti clockwise,1st quarter.");
            BlocProvider.of<NavigationBloc>(context)
                .add(SpinSteeringWheelEvent(isClockwise: false));
          }
          xLastMeasure = v.localPosition.dx;
          yLastMeasure = v.localPosition.dy;
        },
        onPanEnd: (v) {},
        child: Image.asset(
          'assets/images/gameBoard/boat_steering.png',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
      ),
    ),
  );
}
