import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:catchfish/features/gameBoard/domain/entities/choose_random_location_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  String? chosenValue = "switch_location".tr();
  late GoogleMapController googleMapController;
  List<String> locationsMarinas = [
    "switch_location".tr(),
    "Haifa^^^32.80551^^^35.03183",
    "Herzlia^^^32.16412206929472^^^34.79452424482926",
    "Tel Aviv^^^32.086293551588625^^^34.76733140869999",
    "Ashkelon^^^31.681840821451587^^^34.556773296821696"
  ];

  late Marker origin;
  late Marker destination;
  late CameraPosition initialCameraPosition;

  MapBloc() : super(MapInitial()) {
    on<MapEvent>((event, emit) {
      if (event is ChooseRandomLocationEvent) {
        int random = Random().nextInt(4) + 1;
        String temp1 = locationsMarinas[random];
        List<String> temp2 = temp1.split("^^^");
        String marinaName = temp2[0];
        double marinaLatitude = double.parse(temp2[1]);
        double marinaLongitude = double.parse(temp2[2]);
        origin = Marker(
          markerId: const MarkerId("Origin"),
          infoWindow: const InfoWindow(title: "Origin"),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(marinaLatitude, marinaLongitude),
        );
        destination = const Marker(
          markerId: MarkerId("Target"),
          infoWindow: InfoWindow(title: "Target"),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(0, 0),
        );
        initialCameraPosition = CameraPosition(
          target: LatLng(marinaLatitude, marinaLongitude),
          zoom: 17,
        );
        emit(ChooseRandomLocationState(
            marinaName: marinaName,
            origin: origin,
            destination: destination,
            initialCameraPosition: initialCameraPosition));
      } else if (event is RevertLocationEvent) {
        emit(RevertLocationState());
      }
    });
  }
}
