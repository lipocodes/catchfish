import 'package:catchfish/features/fishingShop/presentation/blocs/bloc/fishingshop_bloc.dart';
import 'package:catchfish/features/fishingShop/presentation/pages/fishing_shop.dart';
import 'package:catchfish/features/introduction/presentation/blocs/bloc/introduction_bloc.dart';
import 'package:catchfish/features/introduction/presentation/pages/splash.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/lobby/presentation/pages/lobby.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/apple_sign_in.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/facebook_sign_in.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/google_sign_in.dart';

import 'package:catchfish/features/login/presentation/pages/login.dart';
import 'package:catchfish/features/settings/presentation/blocs/bloc/inventory_bloc.dart';
import 'package:catchfish/features/settings/presentation/pages/equipment_inventory.dart';
import 'package:catchfish/features/tokens/presentation/blocs/bloc/tokens_bloc.dart';
import 'package:catchfish/features/tokens/presentation/pages/buy_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as UI;

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
    UI.TextDirection direction = UI.TextDirection.ltr;
    return MultiBlocProvider(
      providers: [
        BlocProvider<IntroductionBloc>(
            create: (BuildContext context) => IntroductionBloc()),
        BlocProvider<LobbyBloc>(
          create: (BuildContext context) => LobbyBloc(),
        ),
        BlocProvider<InventoryBloc>(
          create: (BuildContext context) => InventoryBloc(),
        ),
        BlocProvider<FishingshopBloc>(
          create: (BuildContext context) => FishingshopBloc(),
        ),
        BlocProvider<TokensBloc>(
          create: (BuildContext context) => TokensBloc(),
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
          child: Directionality(
            textDirection: direction,
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
                  case '/equipment_inventory':
                    return PageTransition(
                      child: const EquipmentInventory(),
                      type: PageTransitionType.fade,
                      settings: settings,
                      duration: const Duration(milliseconds: 1000),
                    );
                  case '/fishing_shop':
                    return PageTransition(
                      child: const FishingShop(),
                      type: PageTransitionType.fade,
                      settings: settings,
                      duration: const Duration(milliseconds: 1000),
                    );
                  case '/buy_tokens':
                    return PageTransition(
                      child: const BuyTokens(),
                      type: PageTransitionType.fade,
                      settings: settings,
                      duration: const Duration(milliseconds: 1000),
                    );
                  default:
                    return null;
                }
              },
            ),
          )),
    );
  }
}
