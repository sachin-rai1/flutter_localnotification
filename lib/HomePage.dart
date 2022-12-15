import 'package:date_format/date_format.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _header(),
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 10),
              height: 100,
              child: DatePicker(
                  selectionColor: primaryColor,
                  selectedTextColor: Colors.white,
                  initialSelectedDate: DateTime.now(),
                  DateTime.now()),
            )
          ],
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
          onTap: () {},
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
}
