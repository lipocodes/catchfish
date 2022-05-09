import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainGameBoard extends StatefulWidget {
  const MainGameBoard({Key? key}) : super(key: key);

  @override
  State<MainGameBoard> createState() => _MainGameBoardState();
}

class _MainGameBoardState extends State<MainGameBoard> {
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
  late Marker destination = const Marker(
    markerId: MarkerId("Target"),
    infoWindow: InfoWindow(title: "Target"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(0, 0),
  );
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 17,
  );

  @override
  void dispose() {
    super.dispose();
    googleMapController.dispose();
  }

  //when entering this screen, need to randomly choose  a location
  chooseRandomLocation() {
    int random = Random().nextInt(4);
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

    initialCameraPosition = CameraPosition(
      target: LatLng(marinaLatitude, marinaLongitude),
      zoom: 17,
    );
    setState(() {
      chosenValue = marinaName;
    });
  }

  moveToSelectedLocation(int indexSelectedItem) {
    String temp1 = locationsMarinas[indexSelectedItem];
    List<String> temp2 = temp1.split("^^^");
    double marinaLatitude = double.parse(temp2[1]);
    double marinaLongitude = double.parse(temp2[2]);
    origin = Marker(
      markerId: const MarkerId("Origin"),
      infoWindow: const InfoWindow(title: "Origin"),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(marinaLatitude, marinaLongitude),
    );

    initialCameraPosition = CameraPosition(
      target: LatLng(marinaLatitude, marinaLongitude),
      zoom: 17,
    );
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition));
  }

  //change the existing location
  changeExistingLocation(int indexNewLocation) {
    chooseRandomLocation();
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition));
  }

  @override
  void initState() {
    super.initState();
    chooseRandomLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (controller) => googleMapController = controller,
              markers: {origin, destination},
              onLongPress: addMarker,
            ),
            dropDown(),
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
      ),
    );
  }

  void addMarker(LatLng pos) {
    print("addMarker!");
  }

  void onChangedDropDown(String? selection) {
    for (int a = 1; a < locationsMarinas.length; a++) {
      String temp1 = locationsMarinas[a];
      List<String> temp2 = temp1.split("^^^");
      String locationName = temp2[0];
      if (locationName == selection) {
        moveToSelectedLocation(a);
      }
    }
    setState(() {
      chosenValue = selection;
    });
  }

  Widget dropDown() {
    List<String> items = [];
    items.add(locationsMarinas[0]);

    for (int a = 1; a < locationsMarinas.length; a++) {
      items.add(
          locationsMarinas[a].substring(0, locationsMarinas[a].indexOf("^^^")));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(0.0),
          child: DropdownButton<String>(
            value: chosenValue,
            //elevation: 5,
            style: const TextStyle(
                color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold),

            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),

            onChanged: onChangedDropDown,
          ),
        ),
      ],
    );
  }
}
