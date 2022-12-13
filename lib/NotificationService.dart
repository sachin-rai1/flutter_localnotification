import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
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
    priority: Priority.high,
    vibrationPattern: Int64List.fromList([0, 1000, 200, 200, 200, 200, 200, 200]),
    category: AndroidNotificationCategory.alarm,
    importance: Importance.max,
    actions: [
      AndroidNotificationAction("1", "Mark As Read"),
      AndroidNotificationAction("2", "Open"),
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
        "A Notification From My Application",
        "This notification was sent using Flutter Local Notifications Package",
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

// AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 1,
//         channelKey: 'scheduled',
//         title: 'wait 5 seconds to show',
//         body: 'now is 5 seconds later',
//         wakeUpScreen: true,
//         category: NotificationCategory.Alarm,
//       ),
//       schedule: NotificationInterval(
//           interval: 1,
//           repeats: true,
//           preciseAlarm: true,
//           timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()));
// }
}
