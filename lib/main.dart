import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localnotification/AddTask.dart';
import 'package:flutter_localnotification/AlarmClock.dart';
import 'package:flutter_localnotification/Constant.dart';
import 'package:flutter_localnotification/HomePage.dart';
import 'package:flutter_localnotification/db/DbHelper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
  await DbHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: Themes.lightTheme,
      themeMode: ThemeService().theme,
      darkTheme: Themes.darkTheme,
      home: const HomePage(),
      routes: {
        "AddTask":(context)=>const AddTask(),
      },
    );
  }
}

// class Homepage extends StatefulWidget {
//   const Homepage({Key? key}) : super(key: key);
//
//   @override
//   State<Homepage> createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   NotificationService().showNotification();
//                 },
//                 child: const Text("Click Me ")),
//             ElevatedButton(
//                 onPressed: () {
//                   NotificationService().showScheduledNotification();
//                 },
//                 child: const Text("Click Me Scheduled")),
//             ElevatedButton(
//                 onPressed: () {
//                   NotificationService().showScheduledNotification();
//                 },
//                 child: const Text("Snooze")),
//           ],
//         ),
//       ),
//     );
//   }
// }
