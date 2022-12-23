import 'package:flutter/material.dart';
import 'package:flutter_localnotification/AddTask.dart';
import 'package:flutter_localnotification/Constant.dart';
import 'package:flutter_localnotification/NotificationService.dart';
import 'package:flutter_localnotification/db/DbHelper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Call Management/incomingCall.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().init();
  await DbHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}


@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetIncomingCall(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)  {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Themes.lightTheme,
      themeMode: ThemeService().theme,
      darkTheme: Themes.darkTheme,
      home: const GetIncomingCall(),
      routes: {
        "AddTask": (context) => const AddTask(),
        "GetIncomingCall" : (context) => const GetIncomingCall(),

      },
    );
  }
}
