import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localnotification/AlarmClock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NotificationService.dart';
import 'alarmManager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
  // prefs = await SharedPreferences.getInstance();
  // if (!prefs!.containsKey(countKey)) {
  //   await prefs!.setInt(countKey, 0);
  // }
  await NotificationService().init(); // <----

  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const AlarmManager(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  NotificationService().showNotification();
                },
                child: const Text("Click Me ")),
            ElevatedButton(
                onPressed: () {
                  NotificationService().showScheduledNotification();
                },
                child: const Text("Click Me Scheduled")),
            ElevatedButton(
                onPressed: () {
                  NotificationService().showScheduledNotification();
                },
                child: const Text("Snooze")),
          ],
        ),
      ),
    );
  }
}
