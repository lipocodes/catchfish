import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_back.dart';
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
  late SharedPreferences _prefs;
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
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(_marinaLatitude, _marinaLongitude),
    );
    _destination = Marker(
      markerId: const MarkerId("destination"),
      infoWindow: const InfoWindow(title: "destination"),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(_marinaLatitude - 0.001, _marinaLongitude - 0.001),
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
    BlocProvider.of<NavigationBloc>(context).add(LeavingNavigationEvent());
    super.dispose();
    _googleMapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: buttonBack(context),
              actions: [],
            ),
            resizeToAvoidBottomInset: false,
            body: BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                if (state is EnteringNavigationState) {
                  _prepareDataForMap();
                  return Container();
                } else if (state is ShowMapState) {
                  return GoogleMap(
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: _initialCameraPosition,
                    onMapCreated: (controller) =>
                        _googleMapController = controller,
                    markers: {_origin, _destination},
                  );
                } else {
                  return Container();
                }
              },
            )));
  }
}
