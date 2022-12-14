import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localnotification/NotificationService.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'Constant.dart';

class AlarmManager extends StatefulWidget {
  const AlarmManager({Key? key}) : super(key: key);

  @override
  State<AlarmManager> createState() => _AlarmManager();
}

class _AlarmManager extends State<AlarmManager> {

  @override
  void initState()
   {
    super.initState();
     NotificationService().init();
    AndroidAlarmManager.initialize();
  }

  final int _oneShotTaskId = 1;
  final int _oneShotAtTaskId = 2;
  final int _periodicTaskId = 3;

  static void _oneShotTaskCallback() {
    print("One Shot Task Running");
    Vibration.vibrate(pattern: [0, 10000, 500, 20000]);
    // NotificationService().showNotification();
  }

  static void _oneShotAtTaskCallback() {
    print("One Shot At Task Running");
    // NotificationService().showNotification();
    Vibration.vibrate(pattern: [0, 1000, 200, 2000]);
  }

  static void _periodicTaskCallback() {
    print("Periodic Task Running");
    Vibration.vibrate(pattern: [0, 1000, 500, 2000]);
  }

  void _scheduleOneShotAlarm(bool isTimed) async {
    if (isTimed) {
      DateTime chosenDate = await _chooseDate();
      await AndroidAlarmManager.oneShotAt(
          chosenDate, _oneShotAtTaskId, _oneShotAtTaskCallback);
    } else {
      Duration duration = await _chooseDuration();
      await AndroidAlarmManager.oneShot(
          duration, _oneShotTaskId, _oneShotTaskCallback);
    }
  }

  void _schedulePeriodicAlarm() async {
    Duration duration = await _chooseDuration();
    await AndroidAlarmManager.periodic(
        duration, _periodicTaskId, _periodicTaskCallback);
  }

  Future<Duration> _chooseDuration() async {
    String duration = "";
    String durationString = durationSeconds;
    AlertDialog alert = AlertDialog(
      title: const Text("Enter a number for the duration"),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: RadioListTile(
                    title: const Text(durationSeconds),
                    value: durationSeconds,
                    groupValue: durationString,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() => durationString = value);
                      }
                    }),
              ),
              Expanded(
                child: RadioListTile(
                    title: const Text(durationMinutes),
                    value: durationMinutes,
                    groupValue: durationString,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() => durationString = value);
                      }
                    }),
              ),
              Expanded(
                child: RadioListTile(
                    title: const Text(durationHours),
                    value: durationHours,
                    groupValue: durationString,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() => durationString = value);
                      }
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (String text) {
                        duration = text;
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(duration);
          },
          child: const Text("Ok"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        )
      ],
    );

    String? enteredText = await showDialog(
        context: context,
        builder: (context) {
          return alert;
        });

    if (enteredText != null) {
      int time = int.parse(enteredText);
      if (durationString == durationSeconds) {
        return Duration(seconds: time);
      } else if (durationString == durationMinutes) {
        return Duration(minutes: time);
      } else {
        return Duration(hours: time);
      }
    }
    return const Duration(seconds: 0);
  }

  Future<DateTime> _chooseDate() async {
    DateTime? chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022, 7),
        lastDate: DateTime(2101));

    if (chosenDate != null) {
      print(chosenDate);
      return chosenDate;
    }

    return DateTime.now();
  }



  @override
  Widget build(BuildContext context) {
    Map<String, bool> values = {
      '00:00': true,
      '01:00': false,
      '03:00': false,
      '04:00': false,
      '05:00': false,
      '06:00': false,
      '07:00': false,
      '08:00': false,
      '09:00': false,
      '10:14': false,
      '10:15': false,
      '10:16': false,
      '10:17': false,
      '10:18': false,
      '10:19': false,
      '10:37': false,
      '10:38': false,
      '10:39': false,
      '10:40': false,
      '10:41': false,
    };
    var date = "";
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              ThemeService().switchTheme();
              NotificationService().showThemeNotification(
               title: "Theme Changed",
               body: Get.isDarkMode?"Activated light Mode":"Activated Dark Mode",
              );
              print(Get.isDarkMode);
            },
            child: const Icon(CupertinoIcons.moon_fill),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text(
                  appName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: SizedBox(
                        width: 90,
                        height: 50,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              _scheduleOneShotAlarm(false);
                            },
                            icon: const Icon(Icons.plus_one),
                            label: const Text(oneShotAlarm)),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 50,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            _scheduleOneShotAlarm(true);
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: const Text(oneShotAtAlarm)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: SizedBox(
                        width: 112,
                        height: 50,
                        child: ElevatedButton.icon(
                            onPressed: _schedulePeriodicAlarm,
                            icon: const Icon(Icons.watch_later_outlined),
                            label: const Text(periodicAlarm)),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      AndroidAlarmManager.cancel(1);
                      AndroidAlarmManager.cancel(2);
                      AndroidAlarmManager.cancel(3);
                      if (kDebugMode) {
                        print("All Alarm Cancelled");
                      }
                    },
                    child: const Text("Stop All")),
                Expanded(
                  child: ListView(
                      children: values.keys.map((String key) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return CheckboxListTile(
                        // activeColor: Colors.red,
                        selected: true,
                        title: Text(key),
                        value: values[key],
                        onChanged: (value) async {
                          setState(() {
                            values[key] = value!;
                            date = "${formatDate(DateTime.now(), [
                                  yyyy,
                                  '-',
                                  mm,
                                  '-',
                                  dd
                                ])} $key:00.00";
                            if (kDebugMode) {
                              print(date);
                            }
                          });
                          if (values[key] == true) {
                            AndroidAlarmManager.oneShotAt(DateTime.parse(date),
                                _oneShotAtTaskId, _oneShotAtTaskCallback);
                          }
                        },
                      );
                    });
                  }).toList()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
