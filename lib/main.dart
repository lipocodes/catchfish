import 'package:catchfish/features/fishingShop/presentation/blocs/bloc/fishingshop_bloc.dart';
import 'package:catchfish/features/fishingShop/presentation/pages/fishing_shop.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/fishingBloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/selectGroupBloc/selectgroup_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/motion_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/navigation/bloc/navigation_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/weather/bloc/weather_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/navigation.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/fishing.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/personal_shop.dart';
import 'package:catchfish/features/gameBoard/presentation/pages/select_group.dart';
import 'package:catchfish/features/introduction/presentation/blocs/bloc/introduction_bloc.dart';
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
import 'package:workmanager/workmanager.dart';
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

////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//Background ServiceWorker: runs every 15 minutes
Future _showNotificationWithDefaultSound(
    flutterLocalNotificationsPlugin) async {
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'main_channel', "Main_channel",
      importance: Importance.max, priority: Priority.max);

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      12345,
      "A Notification From My Application",
      "This notification was sent using Flutter Local Notifcations Package",
      platformChannelSpecifics,
      payload: 'data');
}

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('steering');
    var settings = InitializationSettings(android: android);
    flutterLocalNotificationsPlugin.initialize(settings,
        onSelectNotification: (v) {});
    _showNotificationWithDefaultSound(flutterLocalNotificationsPlugin);
    return Future.value(true);
    //return Future.error("error");
  });
}

//////////////////////////////////////////////////////////////////////////

Future<void> main() async {
  await di.init();

  WidgetsFlutterBinding.ensureInitialized();
  //register WorkerManager for running background code every 15 minutes
  Workmanager().initialize(
    callbackDispatcher,
  );
  Workmanager().registerPeriodicTask(
    "task1",
    "checkNeedShowEvent",
  );

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

  @override
  void initState() {
    super.initState();

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
        BlocProvider<SelectgroupBloc>(
          create: (BuildContext context) => SelectgroupBloc(),
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
                      child: /*const Splash()*/ const SelectGroup(),
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
                  case '/select_group':
                    return PageTransition(
                      child: const SelectGroup(),
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
