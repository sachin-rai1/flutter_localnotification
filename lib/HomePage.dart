import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:date_format/date_format.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localnotification/AddTask.dart';
import 'package:flutter_localnotification/MyWidgets.dart';
import 'package:get/get.dart';
import 'Constant.dart';
import 'NotificationService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    NotificationService().init();
    AndroidAlarmManager.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [_header(), _calendar()],
        ),
      ),
    );
  }

  _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatDate(DateTime.now(), [MM, ' ', dd, ', ', yyyy]),
          style: const TextStyle(fontSize: 20),
        ),
        MyButton(
          onTap: () {
            Get.to(() =>const AddTask());
          },
          label: 'Add Task',
          height: 50,
          width: 100,
          iconData: CupertinoIcons.add,
          gapWidth: 5,
          circularInt: 10,
        ),
      ],
    );
  }

  _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          NotificationService().showThemeNotification(
            title: "Theme Changed",
            body:
                Get.isDarkMode ? "Activated light Mode" : "Activated Dark Mode",
          );
        },
        child: const Icon(CupertinoIcons.moon_fill),
      ),
    );
  }

  _calendar() {
    return Container(
      color: Get.isDarkMode?Colors.grey:Colors.amberAccent,
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      height: 100,
      child: DatePicker(
          selectionColor:Get.isDarkMode?Colors.black:primaryColor,
          monthTextStyle: Get.isDarkMode
              ? const TextStyle(color: Colors.white)
              : const TextStyle(),
          dayTextStyle: Get.isDarkMode
              ? const TextStyle(color: Colors.white)
              : const TextStyle(),
          dateTextStyle: Get.isDarkMode
              ? const TextStyle(color: Colors.white)
              : const TextStyle(),
          selectedTextColor: Colors.white,
          initialSelectedDate: DateTime.now(), onDateChange: (value) {
        if (kDebugMode) {
          print(value);
        }
      }, DateTime.now()),
    );
  }
}
