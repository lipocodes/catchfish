import 'dart:async';
import 'dart:math';

import 'package:catchfish/core/consts/marinas.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/navigation/navigation_usecases.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/motion_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/weather/bloc/weather_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/fishing.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_ignition.dart';

import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_back.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_spin_left.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_spin_right.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/gear.dart';
import 'package:catchfish/injection_container.dart';
import 'dart:ui' as UI;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool _isNavigationSuccessful = false;
  bool _showedWelcomeDialog = false;
  final AudioCache audioCache = AudioCache(prefix: "assets/sounds/gameBoard/");
  AudioPlayer audioPlayer = AudioPlayer();
  double _xDestination = 0.0;
  double _yDestination = 0.0;
  int _random = 0;
  bool _hasUserStartedNavigation = false;
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
      popDialog('Forecast for Today:', weatherDetails);
    });
  }

  //when entering this screen, need to randomly choose  a location
  changeMarina(bool needRandom, int indexMarina) async {
    if (needRandom == true) {
      _random = Random().nextInt(4) + 1;
      _indexMarina = _random;
    } else {
      _indexMarina = indexMarina;
    }

    String temp1 = locationsMarinas[_indexMarina];

    List<String> temp2 = temp1.split("^^^");
    String marinaName = temp2[0];

    _marinaLatitude = double.parse(temp2[1]);
    _marinaLongitude = double.parse(temp2[2]);

    _origin = Marker(
      markerId: const MarkerId("Origin"),
      infoWindow: const InfoWindow(title: "Origin"),
      icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(64, 64)),
          'assets/images/gameBoard/boat.png'),
      position: LatLng(_marinaLatitude, _marinaLongitude),
    );

    List<String> destinationPoints = destinationPointsMarinas[_indexMarina];
    int rand = Random().nextInt(destinationPoints.length);
    String destinationPoint = destinationPoints[rand];
    List<String> temp3 = destinationPoint.split(",");
    _yDestination = double.parse(temp3[0]);
    _xDestination = double.parse(temp3[1]);
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

    if (needRandom == false) {
      _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition));
    }
    _steeringAngle = initialAngleBoatMarinas[_indexMarina];

    setState(() {
      chosenValue = marinaName;
    });
  }

  _updateOriginMarkerUponNewCoordinate() async {
    //check if we have arrived at the destination
    var distance = pow(
        pow((_yDestination - _marinaLatitude), 2) +
            pow((_xDestination - _marinaLongitude), 2),
        0.5);
    if (distance <= 0.0005) {
      _isNavigationSuccessful = true;
      BlocProvider.of<NavigationBloc>(context).add(SuccessfulNavigationEvent(
          navigationUsecases: sl.get<NavigationUsecases>()));
      await audioCache.play("cheers.mp3");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Fishing()),
      );
    } else {
      _origin = Marker(
        markerId: const MarkerId("Origin"),
        infoWindow: const InfoWindow(title: "Origin"),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)),
            'assets/images/gameBoard/boat.png'),
        //icon: await BitmapDescriptor.defaultMarker,
        position: LatLng(_marinaLatitude, _marinaLongitude),
      );
      _initialCameraPosition = CameraPosition(
        target: LatLng(_marinaLatitude, _marinaLongitude),
        zoom: 17,
      );
      BlocProvider.of<NavigationBloc>(context).add(ShowMapEvent());
    }
  }

  @override
  void initState() {
    super.initState();

    changeMarina(true, 0);
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
                BlocProvider.of<NavigationBloc>(context).add(
                    LeavingNavigationEvent(
                        navigationUsecases: sl.get<NavigationUsecases>()));
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
      position: LatLng(_yDestination, _xDestination),
    );
    BlocProvider.of<NavigationBloc>(context)
        .add(GearEvent(selectedNewPosition: 'N'));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Fishing()),
    );
  }

  popDialog(String title, String content) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  title,
                  textDirection: UI.TextDirection.ltr,
                  style: const TextStyle(
                    fontFamily: 'skullsandcrossbones',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
                content: Text(
                  content,
                  textDirection: UI.TextDirection.ltr,
                  style: const TextStyle(
                    fontFamily: 'skullsandcrossbones',
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                ).tr(),
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
              body: BlocBuilder<MotionBloc, MotionState>(
                builder: (context, state) {
                  if (state is NewCoordinatesState) {
                    _marinaLatitude = state.xCoordinate;
                    _marinaLongitude = state.yCoordinate;
                    _updateOriginMarkerUponNewCoordinate();
                    BlocProvider.of<MotionBloc>(context).add(IdleEvent());
                  } else if (state is IdleState) {
                    if (!_isNavigationSuccessful) {
                      Timer timer = Timer(const Duration(seconds: 1), () {
                        BlocProvider.of<MotionBloc>(context).add(
                            NewCoordinatesEvent(
                                xCoordinate: _marinaLatitude,
                                yCoordinate: _marinaLongitude,
                                isBoatRunning: _isBoatRunning,
                                statusGear: _statusGear,
                                indexMarina: _indexMarina,
                                steeringAngle: _steeringAngle));
                      });
                    }
                  }
                  return BlocBuilder<NavigationBloc, NavigationState>(
                    builder: (context, state) {
                      if (state is EnteringNavigationState) {
                        _updateOriginMarkerUponNewCoordinate();
                        return Container();
                      } else if (state is ShowMapState ||
                          state is SpinSteeringWheelState) {
                        bool isBoatRunning = false;

                        if (state is ShowMapState) {
                          if (!_showedWelcomeDialog) {
                            _showedWelcomeDialog = true;
                            popDialog('navigation_title', "navigation_content");
                          }

                          isBoatRunning = state.isBoatRunning;
                          _statusGear = state.statusGear;
                          //_steeringAngle = state.steeringAngle;

                        } else if (state is SpinSteeringWheelState) {
                          isBoatRunning = state.isBoatRunning;
                          _statusGear = state.statusGear;
                          _steeringAngle = state.steeringAngle * 57.2957795;
                        }

                        List<LatLng> polygonLatLong1 = [];

                        List<String> pointsPolygon =
                            polygonsMarinas[_indexMarina];

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
                      } else if (state is IgnitionState) {
                        _isBoatRunning = state.isBoatRunning;
                        //_steeringAngle = state.steeringAngle;

                        BlocProvider.of<NavigationBloc>(context)
                            .add(ShowMapEvent());
                        return sailing(context, _steeringAngle,
                            state.isBoatRunning, state.statusGear);
                      } else if (state is GearState) {
                        if (state.statusGear != "N") {
                          if (_hasUserStartedNavigation == false) {
                            _hasUserStartedNavigation = true;
                          }
                          BlocProvider.of<MotionBloc>(context).add(
                              NewCoordinatesEvent(
                                  xCoordinate: _marinaLatitude,
                                  yCoordinate: _marinaLongitude,
                                  indexMarina: _indexMarina,
                                  statusGear: _statusGear,
                                  isBoatRunning: _isBoatRunning,
                                  steeringAngle: _steeringAngle));
                        }

                        BlocProvider.of<NavigationBloc>(context)
                            .add(ShowMapEvent());

                        return sailing(
                          context,
                          _steeringAngle,
                          state.isBoatRunning,
                          state.statusGear,
                        );
                      } else if (state is LeavingNavigationState) {
                        return Container();
                      } else {
                        return Container();
                      }
                    },
                  );
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
      label: Text(
        'weather'.tr(),
        style: const TextStyle(
          fontFamily: 'skullsandcrossbones',
        ),
      ),
      icon: const Icon(Icons.cloud, size: 24.0, color: Colors.white),
      onPressed: () async {
        BlocProvider.of<WeatherBloc>(context).add(GetWeatherEvent(
            latitude: _initialCameraPosition.target.latitude,
            longitude: _initialCameraPosition.target.longitude));
      },
    );
  }

  Widget dropDown() {
    void onChangedDropDown(String? selection) {
      for (int a = 1; a < locationsMarinas.length; a++) {
        String temp1 = locationsMarinas[a];
        List<String> temp2 = temp1.split("^^^");
        String locationName = temp2[0];
        if (locationName == selection) {
          changeMarina(false, a);
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
    if (_statusGear == "N") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(0.0),
            child: DropdownButton<String>(
              value: chosenValue,
              //elevation: 5,
              style: const TextStyle(
                  fontFamily: 'skullsandcrossbones',
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
                  child: Center(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'skullsandcrossbones',
                      ),
                    ),
                  ),
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
  }

  Widget sailing(
    BuildContext context,
    double steeringAngle,
    bool isBoatRunning,
    String statusGear,
  ) {
    return Column(
      children: [
        _hasUserStartedNavigation ? Container() : dropDown(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isBoatRunning) ...[
              buttonSpinRight(context, _steeringAngle),
            ],
            const SizedBox(
              width: 10.0,
            ),
            Center(
              child: Text((_steeringAngle).floor().toString() + "\u00b0",
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'skullsandcrossbones',
                  )),
            ),
            const SizedBox(
              width: 10.0,
            ),
            if (_isBoatRunning) ...[
              buttonSpinLeft(context, _steeringAngle),
            ],
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
    );
  }

  Widget buttonSkip(BuildContext context) {
    return ElevatedButton.icon(
      label: Text(
        'skip'.tr(),
        style: const TextStyle(
          fontFamily: 'skullsandcrossbones',
        ),
      ),
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
                    updateOriginMarker();
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
