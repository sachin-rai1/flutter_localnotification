import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localnotification/AddTask.dart';
import 'package:flutter_localnotification/Models/TaskModels.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
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
        // sound: const RawResourceAndroidNotificationSound('tumanmerijaanlovehindi'),
        priority: Priority.high,
        vibrationPattern: Int64List.fromList([0, 1000, 200]),
        category: AndroidNotificationCategory.alarm,
        importance: Importance.max,
        channelAction: AndroidNotificationChannelAction.createIfNotExists,
        actions: [
          const AndroidNotificationAction("1", "Mark As Read"),
          const AndroidNotificationAction("2", "Open"),
        ],
      ),
      iOS: const DarwinNotificationDetails());
  NotificationDetails themePlatformChannelSpecificsconst = const NotificationDetails(
          iOS: DarwinNotificationDetails(),
          android: AndroidNotificationDetails(
            "channelId",
            "channelName",
            ticker: 'ticker',
            channelShowBadge: true,
            enableLights: true,
            color: Colors.green,
            enableVibration: false,
            playSound: true,
            priority: Priority.high,
            category: AndroidNotificationCategory.alarm,
            importance: Importance.max,
          ));

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    await _configureLocalTimezone();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    FlutterLocalNotificationsPlugin().initialize(
      InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS),
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            print(notificationResponse.actionId);
            print("Notification Selected");
            Get.to(const AddTask());
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == "2") {
              print(notificationResponse.actionId);
              Get.to(const AddTask());
            }
            break;
        }
      },
    );
  }

  showNotification() async {
    await flutterLocalNotificationsPlugin.show(
        0, "Your Timer is Up", "Wake Up", platformChannelSpecificsconst,
        payload: "data");
  }

  showThemeNotification({required String title, required String body}) async {
    await flutterLocalNotificationsPlugin.show(
        3, title, body, themePlatformChannelSpecificsconst,
        payload: "data");
  }

  showScheduledNotification(int hour, int minute, TaskData task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.note,
        _convertTime(hour, minute),
        platformChannelSpecificsconst,
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  showAlarmNotification() async {}

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(const Text("Welcome To Flutter"));
  }



  tz.TZDateTime _convertTime(int hour, int minute) {
    print("I am Coverting Time");
    print("Hour ${hour.toString()}");
    print("Minute ${minute.toString()}");

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    print(scheduleDate);

    return scheduleDate;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }
}
