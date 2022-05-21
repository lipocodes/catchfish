import 'dart:async';
import 'dart:math';

import 'package:catchfish/core/consts/marinas.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/motion_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/button_ignition.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_back.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/sailing.dart';
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

  _prepareDataForMap() async {
    _origin = Marker(
      markerId: const MarkerId("Origin"),
      infoWindow: const InfoWindow(title: "Origin"),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(64, 64)),
          'assets/images/gameBoard/boat.png'),
      position: LatLng(_marinaLatitude, _marinaLongitude),
    );

    double y = _prefs.getDouble("yDestination") ?? 0.0;
    double x = _prefs.getDouble("xDestination") ?? 0.0;
    _destination = Marker(
      markerId: const MarkerId("destination"),
      infoWindow: const InfoWindow(title: "destination"),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(64, 64)),
          'assets/images/gameBoard/anchor.png'),
      position: LatLng(y, x),
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
    _indexMarina = _prefs.getInt("indexMarina") ?? 0;
    _marinaLatitude = _prefs.getDouble("marinaLatitude") ?? 0.0;
    _marinaLongitude = _prefs.getDouble("marinaLongitude") ?? 0.0;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _retreivePrefs();
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

  updateOriginMarker() async {
    _origin = Marker(
      markerId: const MarkerId("Origin"),
      infoWindow: const InfoWindow(title: "Origin"),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(64, 64)),
          'assets/images/gameBoard/boat.png'),
      position: LatLng(_marinaLatitude, _marinaLongitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () => returnBack(),
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: buttonBack(context),
            actions: [
              if (!_skipPerformed) ...[
                buttonSkip(
                  context,
                ),
              ],
              const SizedBox(
                width: 80.0,
              ),
              buttonMap(),
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
                    fillColor: Colors.transparent,
                    strokeColor: Colors.transparent,
                    strokeWidth: 2,
                    onTap: () {
                      // Do something
                    },
                  ),
                };
                BlocProvider.of<NavigationBloc>(context).add(ShowMapEvent());

                return _isMapOpened
                    ? BlocBuilder<MotionBloc, MotionState>(
                        builder: (context, state) {
                          if (state is NewCoordinatesState) {
                            _marinaLatitude = state.xCoordinate;
                            _marinaLongitude = state.yCoordinate;
                            _initialCameraPosition = CameraPosition(
                              target: LatLng(_marinaLatitude, _marinaLongitude),
                              zoom: 17,
                            );
                            updateOriginMarker();

                            /*_googleMapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                    _initialCameraPosition));*/
                            BlocProvider.of<MotionBloc>(context)
                                .add(IdleEvent());
                            //checking if we arrived at destination point
                            double y = _prefs.getDouble("yDestination") ?? 0.0;
                            double x = _prefs.getDouble("xDestination") ?? 0.0;
                            if (pow(_marinaLatitude - y, 2) +
                                    pow(_marinaLongitude - x, 2) <
                                pow(0.001, 2)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    const Text("text_origin_now_destination",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w900,
                                        )).tr(),
                              ));
                            }
                          } else if (state is IdleState) {
                            Timer timer = Timer(const Duration(seconds: 1), () {
                              BlocProvider.of<MotionBloc>(context).add(
                                  NewCoordinatesEvent(
                                      xCoordinate: _marinaLatitude,
                                      yCoordinate: _marinaLongitude,
                                      indexMarina: _indexMarina,
                                      statusGear: _statusGear,
                                      isBoatRunning: _isBoatRunning,
                                      steeringAngle: _steeringAngle));
                            });
                          }

                          return GoogleMap(
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            initialCameraPosition: _initialCameraPosition,
                            onMapCreated: (controller) =>
                                _googleMapController = controller,
                            markers: {_origin, _destination},
                            polygons: poly,
                          );
                          //return Container();
                        },
                      )
                    : sailing(
                        context, _steeringAngle, isBoatRunning, _statusGear);
              } else if (state is IgnitionState) {
                _isBoatRunning = state.isBoatRunning;
                _steeringAngle = state.steeringAngle;

                BlocProvider.of<NavigationBloc>(context).add(ShowMapEvent());
                return sailing(context, _steeringAngle, state.isBoatRunning,
                    state.statusGear);
              } else if (state is GearState) {
                _steeringAngle = state.steeringAngle;
                BlocProvider.of<NavigationBloc>(context).add(ShowMapEvent());
                if (state.statusGear != "N") {
                  BlocProvider.of<MotionBloc>(context).add(NewCoordinatesEvent(
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
          )),
    ));
  }

  ////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  Widget buttonSkip(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
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

                    double y = _prefs.getDouble("yDestination") ?? 0.0;
                    double x = _prefs.getDouble("xDestination") ?? 0.0;
                    _marinaLatitude = y;
                    _marinaLongitude = x;
                    updateOriginMarker();

                    _initialCameraPosition = CameraPosition(
                      target: LatLng(y, x),
                      zoom: 12,
                    );

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

  Widget buttonMap() {
    return IconButton(
        icon: _isMapOpened
            ? const Icon(Icons.map,
                color: Color.fromARGB(255, 243, 13, 13), size: 34.0)
            : const Icon(Icons.map, color: Color(0xFF0000FF), size: 34.0),
        onPressed: () {
          setState(() {
            _isMapOpened ? _isMapOpened = false : _isMapOpened = true;
          });
        });
  }
  ////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////
}
