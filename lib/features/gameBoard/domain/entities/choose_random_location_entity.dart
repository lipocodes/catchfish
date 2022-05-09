import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChooseRandomLocationEntity {
  late Marker origin;
  late Marker destination;
  late CameraPosition initialCameraPosition;
  ChooseRandomLocationEntity(
      {required this.origin,
      required this.destination,
      required this.initialCameraPosition});
}
