import 'dart:async';
import 'dart:math';
import 'package:catchfish/features/fishingShop/presentation/widgets/button_back.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/weather/bloc/weather_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/map/button_go_navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as UI;
import 'package:catchfish/core/consts/marinas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late SharedPreferences _prefs;
  String? chosenValue = "switch_location".tr();
  late GoogleMapController googleMapController;
  int _random = 0;

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
  chooseRandomLocation() async {
    _random = Random().nextInt(4) + 1;
    String temp1 = locationsMarinas[_random];

    List<String> temp2 = temp1.split("^^^");
    String marinaName = temp2[0];
    double marinaLatitude = double.parse(temp2[1]);

    double marinaLongitude = double.parse(temp2[2]);

    origin = Marker(
      markerId: const MarkerId("Origin"),
      infoWindow: const InfoWindow(title: "Origin"),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(64, 64)),
          'assets/images/gameBoard/boat.png'),
      position: LatLng(marinaLatitude, marinaLongitude),
    );
    List<String> destinationPoints = destinationPointsMarinas[_random];
    int rand = Random().nextInt(destinationPoints.length);
    String destinationPoint = destinationPoints[rand];
    List<String> temp3 = destinationPoint.split(",");
    double y = double.parse(temp3[0]);
    double x = double.parse(temp3[1]);
    destination = Marker(
      markerId: const MarkerId("Destination"),
      infoWindow: const InfoWindow(title: "Destination"),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(64, 64)),
          'assets/images/gameBoard/anchor.png'),
      position: LatLng(y, x),
    );

    initialCameraPosition = CameraPosition(
      target: LatLng(marinaLatitude, marinaLongitude),
      zoom: 17,
    );

    await _prefs.setDouble("marinaLatitude", marinaLatitude);
    await _prefs.setDouble("marinaLongitude", marinaLongitude);

    setState(() {
      chosenValue = marinaName;
    });
  }

  showWeatherDetails(String weatherDetails) {
    Timer(const Duration(seconds: 1), () {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  'Forecast for Today:',
                  textDirection: UI.TextDirection.ltr,
                  style: TextStyle(
                    fontFamily: 'skullsandcrossbones',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  weatherDetails,
                  textDirection: UI.TextDirection.ltr,
                  style: const TextStyle(
                    fontFamily: 'skullsandcrossbones',
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ));
    });
  }

  //Retreive existing prefs
  retreivePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    retreivePrefs();

    chooseRandomLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is GetWeatherState) {
            showWeatherDetails(state.weatherDetails);
            return Scaffold(
              body: Stack(
                children: [
                  mapPage(),
                ],
              ),
              backgroundColor: Theme.of(context).primaryColor,
              floatingActionButton: returnToOriginalPosition(),
            );
          } else {
            return Scaffold(
              body: Stack(
                children: [
                  mapPage(),
                ],
              ),
              backgroundColor: Theme.of(context).primaryColor,
              floatingActionButton: returnToOriginalPosition(),
            );
          }
        },
      ),
    );
  }

///////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
  Widget mapPage() {
    return Stack(
      children: [
        map(),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buttonGoNavigation(context),
                buttonBack(
                  context,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dropDown(),
                buttonWeather(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  Widget buttonWeather() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      label: Text('weather'.tr()),
      icon: const Icon(Icons.cloud, size: 24.0, color: Colors.white),
      onPressed: () async {
        BlocProvider.of<WeatherBloc>(context).add(GetWeatherEvent(
            latitude: initialCameraPosition.target.latitude,
            longitude: initialCameraPosition.target.longitude));
      },
    );
  }

  /////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////

  Widget returnToOriginalPosition() {
    return Stack(
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
    );
  }

  ///////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  Widget map() {
    List<LatLng> polygonLatLong1 = [];
    _random = 1;
    List<String> pointsPolygon = polygonsMarinas[_random];
    for (int a = 0; a < pointsPolygon.length; a++) {
      String temp1 = pointsPolygon[a];
      List<String> temp2 = temp1.split(",");
      double y = double.parse(temp2[0]);
      double x = double.parse(temp2[1]);
      polygonLatLong1.add(LatLng(y, x));
    }
    Set<Polygon> poly = <Polygon>{
      Polygon(
        polygonId: const PolygonId("1"),
        points: polygonLatLong1,
        fillColor: Colors.transparent,
        strokeColor: Colors.transparent,
        strokeWidth: 2,
        onTap: () {
          // Do something
        },
      ),
    };
    return GoogleMap(
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (controller) => googleMapController = controller,
      markers: {origin, destination},
      polygons: poly,
    );
    //return Container();
  }

//////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
  Widget dropDown() {
    moveToSelectedLocation(int indexSelectedItem) async {
      String temp1 = locationsMarinas[indexSelectedItem];

      List<String> temp2 = temp1.split("^^^");
      double marinaLatitude = double.parse(temp2[1]);

      double marinaLongitude = double.parse(temp2[2]);
      origin = Marker(
        markerId: const MarkerId("Origin"),
        infoWindow: const InfoWindow(title: "Origin"),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)),
            'assets/images/gameBoard/boat.png'),
        position: LatLng(marinaLatitude, marinaLongitude),
      );
      List<String> destinationPoints = destinationPointsMarinas[_random];
      int rand = Random().nextInt(destinationPoints.length);
      String destinationPoint = destinationPoints[rand];
      List<String> temp3 = destinationPoint.split(",");
      double y = double.parse(temp3[0]);
      double x = double.parse(temp3[1]);

      _prefs.setDouble("yDestination", y);
      _prefs.setDouble("xDestination", x);
      destination = Marker(
        markerId: const MarkerId("Destination"),
        infoWindow: const InfoWindow(title: "Destination"),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)),
            'assets/images/gameBoard/anchor.png'),
        position: LatLng(y, x),
      );
      initialCameraPosition = CameraPosition(
        target: LatLng(marinaLatitude, marinaLongitude),
        zoom: 17,
      );
      await _prefs.setInt("indexMarina", _random);
      await _prefs.setDouble("marinaLatitude", marinaLatitude);
      await _prefs.setDouble("marinaLongitude", marinaLongitude);
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
      BlocProvider.of<WeatherBloc>(context).add(InitialEvent());
    }

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
            icon: const Padding(
                //Icon at tail, arrow bottom is default icon
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.arrow_circle_down_sharp)),
            dropdownColor: Colors.blueAccent.shade100,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(
                  child: Text(
                    value,
                  ),
                ),
              );
            }).toList(),

            onChanged: onChangedDropDown,
          ),
        ),
      ],
    );
  }
}
