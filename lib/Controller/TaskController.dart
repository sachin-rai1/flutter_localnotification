import 'package:get/get.dart';
import '../Models/TaskModels.dart';
import '../db/DbHelper.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    getTasks();
    super.onReady();
  }
  var taskList = <TaskData>[].obs;

  Future<int> addTask({TaskData? task}) async {
    return await DbHelper.insert(task);
  }
  void getTasks() async{
    List<Map<String,dynamic>>tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data) => TaskData.fromJson(data)).toList());
  }

  void delete(TaskData task){
   DbHelper.delete(task);
  }

 void markTaskCompleted(int id) async{
    await DbHelper.update(id);
 }
}
