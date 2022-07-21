import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:catchfish/core/consts/marinas.dart';

Widget map(
    CameraPosition initialCameraPosition,
    GoogleMapController googleMapController,
    Marker origin,
    Marker destination) {
  return GoogleMap(
    myLocationButtonEnabled: false,
    zoomControlsEnabled: false,
    initialCameraPosition: initialCameraPosition,
    onMapCreated: (controller) => googleMapController = controller,
    markers: {origin, destination},
  );
}
