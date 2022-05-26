import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buttonSpinLeft(BuildContext context, double steeringAngle) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    label: Text(
      'left'.tr(),
      style: const TextStyle(
        fontFamily: 'skullsandcrossbones',
      ),
    ),
    icon: const Icon(Icons.rotate_left, size: 24.0, color: Colors.white),
    onPressed: () async {
      BlocProvider.of<NavigationBloc>(context).add(SpinSteeringWheelEvent(
          isClockwise: false, steeringAngle: steeringAngle / 57.2957795));
    },
  );
}
