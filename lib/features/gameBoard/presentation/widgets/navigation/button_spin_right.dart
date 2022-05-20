import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buttonSpinRight(BuildContext context) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    label: Text('right'.tr()),
    icon: const Icon(Icons.rotate_right, size: 24.0, color: Colors.white),
    onPressed: () async {
      BlocProvider.of<NavigationBloc>(context)
          .add(SpinSteeringWheelEvent(isClockwise: true));
    },
  );
}
