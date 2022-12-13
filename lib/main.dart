import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'NotificationService.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // <----
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
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
