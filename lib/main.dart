import 'package:catchfish/features/fishingShop/presentation/blocs/bloc/fishingshop_bloc.dart';
import 'package:catchfish/features/fishingShop/presentation/pages/fishing_shop.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/motion_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/weather/bloc/weather_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/map.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/navigation.dart';
import 'package:catchfish/features/introduction/presentation/blocs/bloc/introduction_bloc.dart';
import 'package:catchfish/features/introduction/presentation/pages/splash.dart';
import 'package:catchfish/features/lobby/presentation/blocs/bloc/lobby_bloc.dart';
import 'package:catchfish/features/lobby/presentation/pages/lobby.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/apple_sign_in.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/facebook_sign_in.dart';
import 'package:catchfish/features/login/presentation/blocs/provider/google_sign_in.dart';
import 'package:catchfish/features/login/presentation/pages/login.dart';
import 'package:catchfish/features/settings/presentation/blocs/bloc/inventory_bloc.dart';
import 'package:catchfish/features/settings/presentation/pages/contact.dart';
import 'package:catchfish/features/settings/presentation/pages/equipment_inventory.dart';
import 'package:catchfish/features/tokens/presentation/blocs/bloc/tokens_bloc.dart';
import 'package:catchfish/features/tokens/presentation/blocs/provider/tokens_provider.dart';
import 'package:catchfish/features/tokens/presentation/pages/buy_tokens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as UI;
import 'package:catchfish/core/consts/marinas.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_important_channel',
  'High Importance Notifications',
  playSound: true,
  importance: Importance.high,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    try {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.max,
            color: Colors.blue,
            playSound: true,
            priority: Priority.high,
            //sound: const RawResourceAndroidNotificationSound('applause'),
            icon: "@mipmap/ic_launcher",
            largeIcon: const DrawableResourceAndroidBitmap('shark'),
          ),
        ),
      );
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeee=" + e.toString());
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  //deals with messages coming in when this app in in the background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //deals with messages coming in when app is in foreground
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = "";

  bool checkPointInsidePolygon(double y, double x, int indexMarina) {
    //Based on Ray Casting algorithm for checking if a point is inside a polygon

    int numIntersections = 0;
    List<String> list = polygonsMarinas[indexMarina];
    //taking every 2 adjacent vertices of the polygon
    for (int a = 0; a < list.length - 1; a++) {
      String temp1 = list[a];
      List<String> temp2 = temp1.split(",");
      //geting their coordinates
      double y1 = double.parse(temp2[0]);
      double x1 = double.parse(temp2[1]);
      temp1 = list[a + 1];
      temp2 = temp1.split(",");
      double y2 = double.parse(temp2[0]);
      double x2 = double.parse(temp2[1]);
      //checking if the ckecked point intesects with the edge run by (x1,y1) and (x2,y2)
      //condition 1: if longitudePoint is between y1,y2
      if (y < y1 == y < y2) {
        continue;
      }
      //condition 2: if we draw an horizontal line from our point to the edge run by (x1,y1) and (x2,y2),
      // is value x of this intersection bigger than value x of our point
      if (x >= ((x2 - x1) * (y - y1) / (y2 - y1) + x1)) {
        double temp = ((x2 - x1) * (x - y1) / (y2 - y1) + x1);
        continue;
      }
      numIntersections = numIntersections + 1;
    }
    print("cccccccccccccccccccccc=" + numIntersections.toString());
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPointInsidePolygon(32.835167, 35.050628, 1);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        try {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                importance: Importance.high,
                priority: Priority.high,
                color: Colors.blue,
                playSound: true,
                //sound: const RawResourceAndroidNotificationSound('applause'),
                icon: "@mipmap/ic_launcher",
                largeIcon: const DrawableResourceAndroidBitmap('shark'),
              ),
            ),
          );
        } catch (e) {
          print("eeeeeeeeeeeeeeeeeeee=" + e.toString());
        }
      }
    });
  }

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
        BlocProvider<WeatherBloc>(
          create: (BuildContext context) => WeatherBloc(),
        ),
        BlocProvider<NavigationBloc>(
          create: (BuildContext context) => NavigationBloc(),
        ),
        BlocProvider<MotionBloc>(
          create: (BuildContext context) => MotionBloc(),
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
            ChangeNotifierProvider(
              create: (_) => TokensProvider(),
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
                      child: const BuyToken(),
                      type: PageTransitionType.fade,
                      settings: settings,
                      duration: const Duration(milliseconds: 1000),
                    );
                  case '/contact':
                    return PageTransition(
                      child: const Contact(),
                      type: PageTransitionType.fade,
                      settings: settings,
                      duration: const Duration(milliseconds: 1000),
                    );
                  case '/map':
                    return PageTransition(
                      child: const Map(),
                      type: PageTransitionType.fade,
                      settings: settings,
                      duration: const Duration(milliseconds: 2000),
                    );
                  case '/navigation':
                    return PageTransition(
                      child: const Navigation(),
                      type: PageTransitionType.fade,
                      settings: settings,
                      duration: const Duration(milliseconds: 2000),
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
