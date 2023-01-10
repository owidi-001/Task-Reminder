import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.model.dart';

final taskController = Provider((ref) => TaskController());

final getTasksController = FutureProvider<List<Task>>((ref) {
  final tasks = ref.read(taskController).getTasks();
  return tasks;
});

class TaskController {
  var taskList = <Task>[];

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task!);
  }

  Future<List<Task>> getTasks() async {
    try {
      List<Map<String, dynamic>> result = await DBHelper.query();
      taskList = result.map((data) => Task.fromMap(data)).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return taskList;
  }

  void delete(Task task) async {
    await DBHelper.delete(task);
  }

  void update(Task task) async {
    await DBHelper.update(task.id!);
  }
}
