import 'package:catchfish/core/consts/marinas.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_back.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/sailing.dart';
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

  returnBack() {
    BlocProvider.of<NavigationBloc>(context).add(LeavingNavigationEvent());
    Navigator.pop(context);
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
              IconButton(
                  icon: _isMapOpened
                      ? const Icon(Icons.map,
                          color: Color.fromARGB(255, 243, 13, 13), size: 34.0)
                      : const Icon(Icons.map,
                          color: Color(0xFF0000FF), size: 34.0),
                  onPressed: () {
                    setState(() {
                      _isMapOpened ? _isMapOpened = false : _isMapOpened = true;
                    });
                  }),
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              if (state is EnteringNavigationState) {
                _prepareDataForMap();
                return Container();
              } else if (state is ShowMapState ||
                  state is SpinSteeringWheelState) {
                bool isBoatRunning = false;
                String statusGear = "N";
                if (state is ShowMapState) {
                  isBoatRunning = state.isBoatRunning;
                  statusGear = state.statusGear;
                } else if (state is SpinSteeringWheelState) {
                  isBoatRunning = state.isBoatRunning;
                  statusGear = state.statusGear;
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
                    fillColor: Colors.blueAccent,
                    strokeColor: Colors.blue,
                    strokeWidth: 2,
                    onTap: () {
                      // Do something
                    },
                  ),
                };
                BlocProvider.of<NavigationBloc>(context).add(ShowMapEvent());

                return _isMapOpened
                    ? /*GoogleMap(
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            initialCameraPosition: _initialCameraPosition,
                            onMapCreated: (controller) =>
                                _googleMapController = controller,
                            markers: {_origin, _destination},
                            polygons: poly,
                          )*/
                    Container()
                    : state is SpinSteeringWheelState
                        ? sailing(context, state.steeringAngle, isBoatRunning,
                            statusGear)
                        : sailing(context, 0.0, isBoatRunning, statusGear);
              } else if (state is IgnitionState) {
                BlocProvider.of<NavigationBloc>(context).add(ShowMapEvent());
                return sailing(
                    context, 0.0, state.isBoatRunning, state.statusGear);
              } else if (state is GearState) {
                BlocProvider.of<NavigationBloc>(context).add(ShowMapEvent());
                return sailing(
                    context, 0.0, state.isBoatRunning, state.statusGear);
              } else {
                return Container();
              }
            },
          )),
    ));
  }
}
