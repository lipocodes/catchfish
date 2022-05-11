import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/navigation/button_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  late SharedPreferences _prefs;
  late double _marinaLatitude;
  late double _marinaLongitude;
  //Retreive existing prefs
  retreivePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _marinaLatitude = _prefs.getDouble("marinaLatitude") ?? 0.0;
    _marinaLongitude = _prefs.getDouble("marinaLongitude") ?? 0.0;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retreivePrefs();

    BlocProvider.of<NavigationBloc>(context).add(EnteringNavigationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: buttonBack(context),
              actions: [],
            ),
            resizeToAvoidBottomInset: false,
            body: const Text("Navigation"));
      },
    ));
  }
}
