import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String taskId;
  final String title;
  final String subTitle;
  final String dateTime;
  final String color;
  final bool isChecked;

  Task({
    this.taskId,
    this.title,
    this.subTitle,
    this.dateTime,
    this.color,
    this.isChecked,
  });

  factory Task.fromjson(QueryDocumentSnapshot taskData, String id) {
    return Task(
      taskId: id,
      title: taskData.data()["title"],
      subTitle: taskData.data()["subTitle"],
      dateTime: taskData.data()["dateTime"],
      color: taskData.data()["color"],
      isChecked: taskData.data()["isChecked"],
    );
  }

  Map<String, dynamic> toMap(String id) {
    return {
      "taskId": id,
      "title": title,
      "subTitle": subTitle,
      "dateTime": dateTime,
      "color": color,
      "isChecked": isChecked,
    };
  }
}
