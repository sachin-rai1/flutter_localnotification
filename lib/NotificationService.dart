import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _notificationService =
      NotificationService._internal();

  NotificationDetails platformChannelSpecificsconst = NotificationDetails(
      android: AndroidNotificationDetails(
    "channelId",
    "channelName",
    ticker: 'ticker',
    channelShowBadge: true,
    enableVibration: true,
    enableLights: true,
    color: Colors.green,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound('tumanmerijaanlovehindi'),
    priority: Priority.high,
    vibrationPattern:
        Int64List.fromList([0, 1000, 200, 1000, 200, 1000, 200, 1000]),
    category: AndroidNotificationCategory.alarm,
    importance: Importance.max,
    actions: [
      const AndroidNotificationAction("1", "Mark As Read"),
      const AndroidNotificationAction("2", "Open"),
    ],
  ));

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    FlutterLocalNotificationsPlugin().initialize(
      InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS),
    );
    tz.initializeTimeZones();
  }

  showNotification() async {
    await flutterLocalNotificationsPlugin.show(
        0,
        "Your Timer is Up",
        "Wake Up",
        platformChannelSpecificsconst,
        payload: "data");
  }

  showScheduledNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        "A Notification From My App",
        "Scheduled Notice",
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
        platformChannelSpecificsconst,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
  showAlarmNotification() async
  {

  }

}
