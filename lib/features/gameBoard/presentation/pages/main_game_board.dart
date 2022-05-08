import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainGameBoard extends StatefulWidget {
  const MainGameBoard({Key? key}) : super(key: key);

  @override
  State<MainGameBoard> createState() => _MainGameBoardState();
}

class _MainGameBoardState extends State<MainGameBoard> {
  late GoogleMapController googleMapController;
  late Marker origin = const Marker(
    markerId: MarkerId("Origin"),
    infoWindow: InfoWindow(title: "Origin"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(32.80551, 35.03183),
  );
  late Marker destination = const Marker(
    markerId: MarkerId("Target"),
    infoWindow: InfoWindow(title: "Target"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(0, 0),
  );
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(32.80551, 35.03183),
    zoom: 17,
  );

  @override
  void dispose() {
    super.dispose();
    googleMapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (controller) => googleMapController = controller,
            markers: {origin, destination},
            onLongPress: addMarker,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
              onPressed: () => googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(initialCameraPosition))),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(initialCameraPosition)),
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 32.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addMarker(LatLng pos) {
    print("addMarker!");
  }
}
