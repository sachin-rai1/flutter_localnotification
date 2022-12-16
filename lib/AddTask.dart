import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localnotification/Constant.dart';
import 'package:flutter_localnotification/MyWidgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "09:00 PM";

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

  String hintTextTitle="";
  String hintTextNote="";
  String hintTextRemind="";

  @override
  Widget build(BuildContext context) {
    final selected = "".obs;
    final repeatSelection = "".obs;
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
              hintstyle: const TextStyle(color: Colors.redAccent),
              hint: hintTextTitle,
              label: "Title",
              controller: titleController,
            ),
            MyTextField(
              hint: hintTextNote,
              hintstyle: const TextStyle(color: Colors.redAccent),
              label: "Note",
              controller: noteController,
            ),
            _dateSelection(),
            _timeSelection(),
            MyTextField(
                controller: remindController,
                hintstyle: const TextStyle(color: Colors.redAccent),
                label: "Remind",
                hint: hintTextRemind,
                widget: Obx(
                  () => DropdownButton(
                    hint: const Text(
                      'Select',
                      style: TextStyle(fontSize: 16, color: primaryColor),
                    ),
                    onChanged: (newValue) {
                      selected(newValue);
                    },
                    value: selected.value == "" ? null : selected.value,
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
                )),
            Obx(() => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    hint: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: const Text(
                          'Select',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )),
                    onChanged: (newValue) {
                      repeatSelection(newValue);
                    },
                    value: repeatSelection.value == ""
                        ? null
                        : repeatSelection.value,
                    items: repeat.map((selectedType) {
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
                )),
            Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(right: 15),
                child: MyButton(
                  onTap: () {
                    _validateData();
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
        hintTextTitle= "Please Enter Title";
      });
      Fluttertoast.showToast(msg: "Enter Title");


    } else if (noteController.text.isEmpty) {
      setState(() {
        hintTextNote= "Please Enter Title";
      });
      Get.snackbar("Please Input Note", "");
    } else if (remindController.text.isEmpty) {
      setState(() {
        hintTextRemind = "Please Enter Reminder";
      });
      Get.snackbar("Remind Time", "");
    }

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
}
