import 'dart:async';
import 'dart:math';

import 'package:catchfish/core/consts/marinas.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/motion_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/weather/bloc/weather_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/button_ignition.dart';

import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_back.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_spin_left.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_spin_right.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/gear.dart';
import 'dart:ui' as UI;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  double _xDestination = 0.0;
  double _yDestination = 0.0;
  int _random = 0;
  late Marker origin;
  late Marker destination = const Marker(
    markerId: MarkerId("Target"),
    infoWindow: InfoWindow(title: "Target"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(0, 0),
  );
  String? chosenValue = "switch_location".tr();
  bool _skipPerformed = false;
  double _steeringAngle = 0.0;
  bool _isBoatRunning = false;
  String _statusGear = "N";
  bool _isMapOpened = false;
  late SharedPreferences _prefs;
  int _indexMarina = 0;
  double _marinaLatitude = 0.0;
  double _marinaLongitude = 0.0;
  late GoogleMapController _googleMapController;
  late Marker _origin = Marker(
    markerId: const MarkerId("Origin"),
    infoWindow: const InfoWindow(title: "Origin"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(_marinaLatitude, _marinaLongitude),
  );
  late Marker _destination = Marker(
    markerId: const MarkerId("destination"),
    infoWindow: const InfoWindow(title: "destination"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(_marinaLatitude - 0.001, _marinaLongitude - 0.001),
  );
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(0.0, 0.0),
    zoom: 17,
  );

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

  //when entering this screen, need to randomly choose  a location
  chooseRandomLocation() async {
    _random = Random().nextInt(4) + 1;
    _indexMarina = _random;
    String temp1 = locationsMarinas[_random];

    List<String> temp2 = temp1.split("^^^");
    String marinaName = temp2[0];

    _marinaLatitude = double.parse(temp2[1]);
    _marinaLongitude = double.parse(temp2[2]);

    origin = Marker(
      markerId: const MarkerId("Origin"),
      infoWindow: const InfoWindow(title: "Origin"),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(64, 64)),
          'assets/images/gameBoard/boat.png'),
      position: LatLng(_marinaLatitude, _marinaLongitude),
    );

    List<String> destinationPoints = destinationPointsMarinas[_random];
    int rand = Random().nextInt(destinationPoints.length);
    String destinationPoint = destinationPoints[rand];
    List<String> temp3 = destinationPoint.split(",");
    _yDestination = double.parse(temp3[0]);
    _xDestination = double.parse(temp3[1]);

    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(_marinaLatitude, _marinaLongitude),
      zoom: 17,
    );
    await _prefs.setInt("indexMarina", _random);
    await _prefs.setDouble("marinaLatitude", _marinaLatitude);
    await _prefs.setDouble("marinaLongitude", _marinaLongitude);

    setState(() {
      chosenValue = marinaName;
    });
  }

  _prepareDataForMap() async {
    _origin = Marker(
      markerId: const MarkerId("Origin"),
      infoWindow: const InfoWindow(title: "Origin"),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(64, 64)),
          'assets/images/gameBoard/boat.png'),
      position: LatLng(_marinaLatitude, _marinaLongitude),
    );

    _destination = Marker(
      markerId: const MarkerId("destination"),
      infoWindow: const InfoWindow(title: "destination"),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(64, 64)),
          'assets/images/gameBoard/anchor.png'),
      position: LatLng(_yDestination, _xDestination),
    );
    _initialCameraPosition = CameraPosition(
      target: LatLng(_marinaLatitude, _marinaLongitude),
      zoom: 17,
    );

    BlocProvider.of<NavigationBloc>(context).add(ShowMapEvent());
  }

  //Retreive existing prefs
  _retreivePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    //_indexMarina = _prefs.getInt("indexMarina") ?? 0;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _retreivePrefs();

    chooseRandomLocation();
    BlocProvider.of<NavigationBloc>(context).add(EnteringNavigationEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  returnBack() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "leave_game",
            style: TextStyle(
              fontFamily: 'skullsandcrossbones',
            ),
          ).tr(),
          content: const Text(
            "text_leave_game",
            style: TextStyle(
              fontFamily: 'skullsandcrossbones',
            ),
          ).tr(),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                BlocProvider.of<NavigationBloc>(context)
                    .add(LeavingNavigationEvent());
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue,
                    fontFamily: 'skullsandcrossbones',
                  )).tr(),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('cancel',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue,
                    fontFamily: 'skullsandcrossbones',
                  )).tr(),
            ),
          ],
        );
      },
    );
  }

  skipOriginMarker() async {
    _origin = Marker(
      markerId: const MarkerId("Origin"),
      infoWindow: const InfoWindow(title: "Origin"),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(64, 64)),
          'assets/images/gameBoard/boat.png'),
      position: LatLng(_yDestination, _xDestination),
    );
  }

  updateCoordinatesOriginMarker() async {
    _origin = Marker(
      markerId: const MarkerId("Origin"),
      infoWindow: const InfoWindow(title: "Origin"),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(64, 64)),
          'assets/images/gameBoard/boat.png'),
      position: LatLng(_yDestination, _xDestination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () => returnBack(),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is GetWeatherState) {
            BlocProvider.of<WeatherBloc>(context).add(InitialEvent());
            showWeatherDetails(state.weatherDetails);
          }

          return Scaffold(
              //extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: buttonBack(context),
                actions: [
                  Row(
                    children: [
                      buttonWeather(),
                      const SizedBox(
                        width: 10.0,
                      ),
                      if (!_skipPerformed) ...[
                        buttonSkip(
                          context,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              body: BlocBuilder<NavigationBloc, NavigationState>(
                builder: (context, state) {
                  if (state is EnteringNavigationState) {
                    _prepareDataForMap();

                    return Container();
                  } else if (state is ShowMapState ||
                      state is SpinSteeringWheelState) {
                    bool isBoatRunning = false;

                    if (state is ShowMapState) {
                      isBoatRunning = state.isBoatRunning;
                      _statusGear = state.statusGear;
                      _steeringAngle = state.steeringAngle;
                    } else if (state is SpinSteeringWheelState) {
                      isBoatRunning = state.isBoatRunning;
                      _statusGear = state.statusGear;
                    }
                    List<LatLng> polygonLatLong1 = [];

                    List<String> pointsPolygon = polygonsMarinas[_indexMarina];

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
                        fillColor: Colors.blue,
                        strokeColor: Colors.blue,
                        strokeWidth: 10,
                        onTap: () {
                          // Do something
                        },
                      ),
                    };
                    BlocProvider.of<NavigationBloc>(context)
                        .add(ShowMapEvent());

                    return BlocBuilder<MotionBloc, MotionState>(
                      builder: (context, state) {
                        if (state is NewCoordinatesState) {
                          _marinaLatitude = state.xCoordinate;
                          _marinaLongitude = state.xCoordinate;
                          updateCoordinatesOriginMarker();
                        }

                        return Column(
                          children: [
                            SizedBox(
                              height: 500.0,
                              child: Stack(
                                children: [
                                  GoogleMap(
                                    myLocationButtonEnabled: false,
                                    zoomControlsEnabled: false,
                                    initialCameraPosition:
                                        _initialCameraPosition,
                                    onMapCreated: (controller) =>
                                        _googleMapController = controller,
                                    markers: {_origin, _destination},
                                    polygons: poly,
                                  ),
                                ],
                              ),
                            ),
                            sailing(
                              context,
                              _steeringAngle,
                              _isBoatRunning,
                              _statusGear,
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is IgnitionState) {
                    _isBoatRunning = state.isBoatRunning;
                    _steeringAngle = state.steeringAngle;

                    BlocProvider.of<NavigationBloc>(context)
                        .add(ShowMapEvent());
                    return sailing(context, _steeringAngle, state.isBoatRunning,
                        state.statusGear);
                  } else if (state is GearState) {
                    _steeringAngle = state.steeringAngle;
                    BlocProvider.of<NavigationBloc>(context)
                        .add(ShowMapEvent());
                    if (state.statusGear != "N") {
                      BlocProvider.of<MotionBloc>(context).add(
                          NewCoordinatesEvent(
                              xCoordinate: _marinaLatitude,
                              yCoordinate: _marinaLongitude,
                              indexMarina: _indexMarina,
                              statusGear: _statusGear,
                              isBoatRunning: _isBoatRunning,
                              steeringAngle: _steeringAngle));
                    }

                    return sailing(
                      context,
                      _steeringAngle,
                      state.isBoatRunning,
                      state.statusGear,
                    );
                  } else {
                    return Container();
                  }
                },
              ));
        },
      ),
    ));
  }

  ////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////
  Widget returnToOriginalPosition() {
    return Stack(
      children: [
        FloatingActionButton(
            onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(_initialCameraPosition))),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(_initialCameraPosition)),
            child: const Icon(
              Icons.refresh,
              color: Colors.white,
              size: 24.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget buttonWeather() {
    return ElevatedButton.icon(
      label: Text('weather'.tr()),
      icon: const Icon(Icons.cloud, size: 24.0, color: Colors.white),
      onPressed: () async {
        BlocProvider.of<WeatherBloc>(context).add(GetWeatherEvent(
            latitude: _initialCameraPosition.target.latitude,
            longitude: _initialCameraPosition.target.longitude));
      },
    );
  }

  Widget dropDown() {
    moveToSelectedLocation(int indexSelectedItem) async {
      _indexMarina = indexSelectedItem;
      String temp1 = locationsMarinas[indexSelectedItem];

      List<String> temp2 = temp1.split("^^^");
      double marinaLatitude = double.parse(temp2[1]);

      double marinaLongitude = double.parse(temp2[2]);

      _origin = Marker(
        markerId: const MarkerId("Origin"),
        infoWindow: const InfoWindow(title: "Origin"),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)),
            'assets/images/gameBoard/boat.png'),
        position: LatLng(marinaLatitude, marinaLongitude),
      );

      List<String> destinationPoints =
          destinationPointsMarinas[indexSelectedItem];
      int rand = Random().nextInt(destinationPoints.length);
      String destinationPoint = destinationPoints[rand];
      List<String> temp3 = destinationPoint.split(",");
      double y = double.parse(temp3[0]);
      double x = double.parse(temp3[1]);

      _destination = Marker(
        markerId: const MarkerId("Destination"),
        infoWindow: const InfoWindow(title: "Destination"),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)),
            'assets/images/gameBoard/anchor.png'),
        position: LatLng(y, x),
      );

      _initialCameraPosition = CameraPosition(
        target: LatLng(marinaLatitude, marinaLongitude),
        zoom: 17,
      );

      _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition));
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

  Widget sailing(
    BuildContext context,
    double steeringAngle,
    bool isBoatRunning,
    String statusGear,
  ) {
    return Positioned(
      bottom: 0.0,
      child: Column(
        children: [
          dropDown(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonSpinRight(context, _steeringAngle),
              const SizedBox(
                width: 10.0,
              ),
              Center(
                child: Text(
                    (_steeringAngle * 57.2957795).floor().toString() + "\u00b0",
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(
                width: 10.0,
              ),
              buttonSpinLeft(context, _steeringAngle),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 64.0,
                  height: 64.0,
                  child: buttonIgnition(context, isBoatRunning)),
              isBoatRunning ? gear(context, _statusGear) : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonSkip(BuildContext context) {
    return ElevatedButton.icon(
      label: Text('skip'.tr()),
      icon: const Icon(Icons.rotate_left, size: 24.0, color: Colors.white),
      onPressed: () async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "skip_navigation",
                style: TextStyle(
                  fontFamily: 'skullsandcrossbones',
                ),
              ).tr(),
              content: const Text(
                "text_skip_navigation",
                style: TextStyle(
                  fontFamily: 'skullsandcrossbones',
                ),
              ).tr(),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _skipPerformed = true;
                    });

                    Navigator.pop(context);

                    skipOriginMarker();

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("text_origin_now_destination",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                          )).tr(),
                    ));
                  },
                  child: const Text('OK',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.blue,
                        fontFamily: 'skullsandcrossbones',
                      )).tr(),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('cancel',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.blue,
                        fontFamily: 'skullsandcrossbones',
                      )).tr(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
}
