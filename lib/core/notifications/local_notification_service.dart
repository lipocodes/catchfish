import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  late NotificationDetails platformChannelSpecifics;
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_important_channel',
    'High Importance Notifications',
    playSound: true,
    importance: Importance.high,
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  initLocalNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('steering');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (v) {
      print("xxxxxxxxxxxxxxxxxxxxx");
    });
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'main_channel', "Main_channel",
        importance: Importance.max, priority: Priority.max);
    platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        12345,
        "A Notification From My Application",
        "This notification was sent using Flutter Local Notifcations Package",
        platformChannelSpecifics,
        payload: 'data');
  }
}
