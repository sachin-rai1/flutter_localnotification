import 'dart:convert';

List<TaskData> taskDataFromJson(String str) => List<TaskData>.from(json.decode(str).map((x) => TaskData.fromJson(x)));

String taskDataToJson(List<TaskData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskData {
  TaskData({
    this.id,
    this.title,
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.remind,
    this.repeat,
    this.isCompleted,
  });

  int? id;
  String? title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  int? remind;
  String? repeat;
  int? isCompleted;

  factory TaskData.fromJson(Map<String, dynamic> json) => TaskData(
    id: json["id"],
    title: json["title"],
    note: json["note"],
    date: json["date"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    remind: json["remind"],
    repeat: json["repeat"],
    isCompleted: json["isCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "note": note,
    "date": date,
    "startTime": startTime,
    "endTime": endTime,
    "remind": remind,
    "repeat": repeat,
    "isCompleted": isCompleted,
  };
}
