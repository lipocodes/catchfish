import 'dart:math';
import 'package:catchfish/features/gameBoard/presentation/blocs/map/bloc/map_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: mapPage(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

///////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
  Widget mapPage() {
    BlocProvider.of<MapBloc>(context).add(ChooseRandomLocationEvent());
    return Stack(
      children: [
        map(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            dropDown(),
            buttonReturnOriginalPosition(),
          ],
        ),
      ],
    );
  }

  /////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  Widget buttonReturnOriginalPosition() {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is ChooseRandomLocationState) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Text('revert'.tr()),
            onPressed: () {
              googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(state.initialCameraPosition));
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  ///////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  Widget map() {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is ChooseRandomLocationState) {
          return GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: state.initialCameraPosition,
            onMapCreated: (controller) => googleMapController = controller,
            markers: {state.origin, state.destination},
          );
        } else {
          return Container();
        }
      },
    );
  }

//////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
  Widget dropDown() {
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

    List<String> items = [];
    items.add(locationsMarinas[0]);

    for (int a = 1; a < locationsMarinas.length; a++) {
      items.add(
          locationsMarinas[a].substring(0, locationsMarinas[a].indexOf("^^^")));
    }

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is ChooseRandomLocationState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(0.0),
                child: DropdownButton<String>(
                  value: state.marinaName,
                  //elevation: 5,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                  icon: const Padding(
                      //Icon at tail, arrow bottom is default icon
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.arrow_circle_down_sharp)),
                  dropdownColor: Colors.blueAccent.shade100,
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
        } else {
          return Container();
        }
      },
    );
  }
}
