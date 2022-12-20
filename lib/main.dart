import 'package:flutter/material.dart';
import 'package:flutter_localnotification/AddTask.dart';
import 'package:flutter_localnotification/Call%20Management/callHistory.dart';
import 'package:flutter_localnotification/Constant.dart';
import 'package:flutter_localnotification/db/DbHelper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workmanager/workmanager.dart';

import 'Call Management/incomingCall.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // IsolateNameServer.registerPortWithName(
  //   port.sendPort,
  //   isolateName,
  // );
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
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
      home: const CallHistory(),
      routes: {
        "AddTask": (context) => const AddTask(),
      },
    );
  }
}
