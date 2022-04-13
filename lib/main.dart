import 'package:catchfish/features/introduction/presentation/blocs/bloc/introduction_bloc.dart';
import 'package:catchfish/features/introduction/presentation/pages/splash.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/lobby/presentation/pages/lobby.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/apple_sign_in.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/facebook_sign_in.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/google_sign_in.dart';

import 'package:catchfish/features/login/presentation/pages/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseCrashlytics.instance.crash();
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: const [
      Locale('he', ''),
      Locale('ar', ''),
      Locale('en', 'US'),
    ],
    path: 'assets/translations',
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IntroductionBloc>(
            create: (BuildContext context) => IntroductionBloc()),
        BlocProvider<LobbyBloc>(
          create: (BuildContext context) => LobbyBloc(),
        ),
      ],
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppleSignInProvider()),
            ChangeNotifierProvider(
              create: (_) => FacebookSignInProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => GoogleSignInProvider(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return PageTransition(
                    child: const Splash(),
                    type: PageTransitionType.fade,
                    settings: settings,
                    duration: const Duration(milliseconds: 1000),
                  );
                case '/login':
                  return PageTransition(
                    child: const Login(),
                    type: PageTransitionType.fade,
                    settings: settings,
                    duration: const Duration(milliseconds: 1000),
                  );
                case '/lobby':
                  return PageTransition(
                    child: const Lobby(),
                    type: PageTransitionType.fade,
                    settings: settings,
                    duration: const Duration(milliseconds: 1000),
                  );

                default:
                  return null;
              }
            },
          )),
    );
  }
}
