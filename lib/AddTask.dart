import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localnotification/Constant.dart';
import 'package:flutter_localnotification/Controller/TaskController.dart';

import 'package:flutter_localnotification/Models/TaskModels.dart';
import 'package:flutter_localnotification/MyWidgets.dart';
import 'package:flutter_localnotification/NotificationService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

  String _endTime = Get.mediaQuery.alwaysUse24HourFormat?"21:00":"09:00 PM";

  List<String> scheduleTime = ["Seconds", "Minutes", "Hours"];
  List<String> repeat = [
    "Once",
    "Daily",
    "Weekly",
    "Monthly",
    "Yearly",
    "Never"
  ];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController remindController = TextEditingController();

  String hintTextTitle = "";
  String hintTextNote = "";
  String hintTextRemind = "";
  final reminderSelection = "".obs;
  final repeatSelection = "".obs;
  final Rx<bool> isOnTapBlank = false.obs;
  final Rx<bool> isOnTapValidate = true.obs;
  late FocusNode titleFocus;
  late FocusNode noteFocus;
  late FocusNode remindFocus;
  late FocusNode remindSelectionFocus;
  late FocusNode repeatSelectionFocus;

  @override
  void initState() {
    super.initState();
    titleFocus = FocusNode();
    noteFocus = FocusNode();
    remindFocus = FocusNode();
    remindSelectionFocus = FocusNode();
    repeatSelectionFocus = FocusNode();
  }
  String _startTime =Get.mediaQuery.alwaysUse24HourFormat?DateFormat("HH:mm").format(DateTime.now()).toString():DateFormat("hh:mm a").format(DateTime.now()).toString();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              focusNode: titleFocus,
              hintstyle: isOnTapBlank.value == true
                  ? const TextStyle(color: Colors.redAccent)
                  : const TextStyle(),
              hint: hintTextTitle,
              label: "Title",
              controller: titleController,
            ),
            Obx(
              () => MyTextField(
                focusNode: noteFocus,
                hint: hintTextNote,
                hintstyle: isOnTapBlank.value == true
                    ? const TextStyle(color: Colors.redAccent)
                    : const TextStyle(),
                label: "Note",
                controller: noteController,
              ),
            ),
            _dateSelection(),
            _timeSelection(),
            _reminder(),
            _repeater(),
            Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 15),
                child: MyButton(
                  onTap: () {
                    setState(() {
                      _validateData();
                      if (isOnTapValidate.value == false) {
                        print(isOnTapValidate.value);
                        print("Form Invalid");
                      } else {
                        _addTaskToDb();
                        _addAlarmTodb();

                      }
                    });
                  },
                  label: "Submit",
                  width: 100,
                  height: 40,
                  circularInt: 15,
                )),
          ],
        ),
      ),
    );
  }

  _validateData() {
    if (titleController.text.isEmpty) {
      setState(() {
        hintTextTitle = "Please Enter Title";
        isOnTapBlank.value = true;
        isOnTapValidate.value = false;
        FocusScope.of(context).requestFocus(titleFocus);
      });
    } else if (noteController.text.isEmpty) {
      setState(() {
        hintTextNote = "Please Enter Note";
        isOnTapBlank.value = true;
        isOnTapValidate.value = false;
        FocusScope.of(context).requestFocus(noteFocus);
      });
    } else if (remindController.text.isEmpty) {
      setState(() {
        hintTextRemind = "Please Enter Reminder";
        isOnTapBlank.value = true;
        isOnTapValidate.value = false;
        FocusScope.of(context).requestFocus(remindFocus);
      });
    } else if (remindController.text.isNumericOnly == false) {
      Get.snackbar("Please Enter No. Only", "In Reminder",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      isOnTapValidate.value = false;
      FocusScope.of(context).requestFocus(remindFocus);
    } else if (reminderSelection.value == "") {
      isOnTapBlank.value = true;
      isOnTapValidate.value = false;
      FocusScope.of(context).requestFocus(remindSelectionFocus);
    } else if (repeatSelection.value == "") {
      isOnTapBlank.value = true;
      isOnTapValidate.value = false;
      FocusScope.of(context).requestFocus(remindSelectionFocus);
    } else {
      isOnTapBlank.value = false;
      isOnTapValidate.value = true;

    }
  }

  _addTaskToDb() async{
  int value =  await _taskController.addTask(
        task: TaskData(
      title: titleController.text,
      note: noteController.text.toString(),
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: int.parse(remindController.text),
      repeat: repeatSelection.toString(),
    ));

  // int alarmValue = await _taskController.addAlarm(
  //   alarmTiming: AlarmTiming(
  //     dateTime: NotificationService().scheduleDate.toString()
  //   )
  // );

  // print("Alarm Inserted $alarmValue");
  // print(NotificationService().scheduleDate.toString());

  }

  _timeSelection() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: MyTextField(
            readOnly: true,
            onTap: () {
              setState(() {
                _showTimePicker(isStartTime: true);
              });
            },
            hint: _startTime,
            widget: const Icon(CupertinoIcons.time),
          ),
        ),
        Expanded(
          flex: 2,
          child: MyTextField(
            readOnly: true,
            onTap: () {
              setState(() {
                _showTimePicker(isStartTime: false);
              });
            },
            hint: _endTime,
            widget: const Icon(CupertinoIcons.time),
          ),
        ),
      ],
    );
  }

  _repeater() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
            focusNode: remindSelectionFocus,
            hint: SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Text('Select',
                    style: isOnTapBlank.value == true
                        ? const TextStyle(fontSize: 16, color: Colors.redAccent)
                        : const TextStyle(fontSize: 16))),
            onChanged: (newValue) {
              repeatSelection(newValue);
            },
            value: repeatSelection.value == "" ? null : repeatSelection.value,
            items: repeat.map((selectedType) {
              return DropdownMenuItem(
                value: selectedType,
                child: Text(
                  selectedType,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          ),
        ));
  }

  _reminder() {
    return MyTextField(
        focusNode: remindFocus,
        keyBoardType: TextInputType.number,
        controller: remindController,
        hintstyle: isOnTapBlank.value == true
            ? const TextStyle(color: Colors.redAccent)
            : const TextStyle(),
        label: "Remind",
        hint: hintTextRemind,
        widget: Obx(
          () => DropdownButton(
            focusNode: remindSelectionFocus,
            hint: Text('Select',
                style: isOnTapBlank.value == true
                    ? const TextStyle(fontSize: 16, color: Colors.redAccent)
                    : const TextStyle(fontSize: 16)),
            onChanged: (newValue) {
              reminderSelection(newValue);
            },
            value:
                reminderSelection.value == "" ? null : reminderSelection.value,
            items: scheduleTime.map((selectedType) {
              return DropdownMenuItem(
                value: selectedType,
                child: Text(
                  selectedType,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  _dateSelection() {
    return MyTextField(
      readOnly: true,
      onTap: () {
        _showDatePicker();
      },
      hint: DateFormat.yMMMd().format(_selectedDate),
      widget: const Icon(Icons.calendar_month),
    );
  }

  _showDatePicker() async {
    DateTime? _showDatePicker = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1800),
        lastDate: DateTime(2200));
    if (_showDatePicker != null) {
      setState(() {
        _selectedDate = _showDatePicker;
      });
    }
  }

  _showTimePicker({required bool isStartTime}) async {
    var pickedTime = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ));
    var formattedTime = pickedTime?.format(context);
    if (pickedTime == null) {
      print("Wrong Time");
    }
    if (isStartTime == true) {
      setState(() {
        _startTime = formattedTime!;
      });
    }
    if (isStartTime == false) {
      setState(() {
        _endTime = formattedTime!;
      });
    }
  }

  void _addAlarmTodb() {


  }
}
