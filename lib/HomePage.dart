import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:date_format/date_format.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localnotification/AddTask.dart';
import 'package:flutter_localnotification/Models/TaskModels.dart';
import 'package:flutter_localnotification/MyWidgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'Constant.dart';
import 'Controller/TaskController.dart';
import 'NotificationService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

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
          children: [
            _header(),
            _calendar(),
            _showTask(),
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
          onTap: () async {
            await Get.to(() => const AddTask());
            setState(() {
              _taskController.getTasks();
            });
          },
          label: '+ Add Task',
          height: 50,
          width: 100,
          circularInt: 10,
        ),
      ],
    );
  }

  _showTask() {
    return Expanded(
        child: Obx(
      () => ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (BuildContext context, int index) {
          TaskData task = _taskController.taskList[index];
          if (task.repeat == "Daily") {
            DateTime date = DateFormat.Hm().parse(task.startTime.toString());
            var myTime = DateFormat("HH:mm").format(date);
            for (int i = 0; i < _taskController.taskList.length; i++) {
              NotificationService().showScheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task);
            }

            return GestureDetector(
                onTap: () {
                  _taskController.delete(_taskController.taskList[index]);
                  _taskController.getTasks();
                  print(_taskController.taskList.length);
                },
                child: AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task),
                              ),
                            )
                          ],
                        ),
                      ),
                    )));
          }
          if(task.repeat == "Once"){
            return GestureDetector(
                onTap: () {
                  _taskController.delete(_taskController.taskList[index]);
                  _taskController.getTasks();
                  print(_taskController.taskList.length);
                },
                child: AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task),
                              ),
                            )
                          ],
                        ),
                      ),
                    )));
          }
          if (task.date == DateFormat.yMd().format(_selectedDate)) {
            return GestureDetector(
                onTap: () {
                  _taskController.delete(_taskController.taskList[index]);
                  _taskController.getTasks();
                  print(_taskController.taskList.length);
                },
                child: AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task),
                              ),
                            )
                          ],
                        ),
                      ),
                    )));
          }
          return Container();
        },
      ),
    ));
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
      color: Get.isDarkMode ? Colors.grey : Colors.amberAccent,
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      height: 100,
      child: DatePicker(
          selectionColor: Get.isDarkMode ? Colors.black : primaryColor,
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
        setState(() {
          _selectedDate = value;
          print(_selectedDate);
          print(DateFormat.yMd().format(_selectedDate));
        });
      }, DateTime.now()),
    );
  }

  _showBottomSheet(BuildContext context, TaskData task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height / 6
          : MediaQuery.of(context).size.height / 4,
      color: Get.isDarkMode ? Colors.grey : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
          ),
          task.isCompleted == 1
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                  child: MyButton(
                    color: Colors.blueAccent,
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      _taskController.getTasks();
                      Get.back();
                    },
                    label: "Task Completed",
                    circularInt: 15,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                  )),
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
            child: MyButton(
              color: Colors.pinkAccent,
              onTap: () {
                _taskController.delete(task);
                _taskController.getTasks();
                Get.back();
              },
              label: "Delete Task",
              circularInt: 15,
              height: 50,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
            child: MyButton(
              color: Colors.transparent,
              onTap: () {
                Get.back();
              },
              label: "Close",
              circularInt: 15,
              height: 50,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    ));
  }
}
