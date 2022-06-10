import 'package:catchfish/core/notifications/local_notification_service.dart';
import 'package:catchfish/core/usecases/usecase.dart';
import 'package:catchfish/features/fishingShop/presentation/blocs/bloc/fishingshop_bloc.dart';
import 'package:catchfish/features/fishingShop/presentation/pages/fishing_shop.dart';
import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/bloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/motion_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/weather/bloc/weather_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/navigation.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/fishing.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/personal_shop.dart';
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
import 'package:catchfish/injection_container.dart';
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
import 'injection_container.dart' as di;

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
  await di.init();

  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  //singleton of Local Notification
  NotificationService();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService().initLocalNotification();

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
        BlocProvider<FishingBloc>(
          create: (BuildContext context) => FishingBloc(),
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
                      child: const Splash() /*Fishing()*/,
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
                  case '/personal_shop':
                    return PageTransition(
                      child: const PersonalShop(),
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
                  case '/navigation':
                    return PageTransition(
                      child: const Navigation(),
                      type: PageTransitionType.fade,
                      settings: settings,
                      duration: const Duration(milliseconds: 2000),
                    );
                  case '/fishing':
                    return PageTransition(
                      child: const Fishing(),
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
