import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter_todo/Models/task.dart';
import 'package:firebase_flutter_todo/Models/user_tasks.dart';
import 'package:firebase_flutter_todo/Services/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirestoreStorage extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Auth auth = Auth();

  Future addTask(Task task) async {
    DocumentReference reference = firestore
        .collection("Tasker")
        .doc(auth.userUid)
        .collection("Tasks")
        .doc();
    try {
      await reference.set(task.toMap(reference.id));
    } catch (e) {
      print(e.toString());
    }
  }

  Future addUserCred(UserTask userTask) async {
    DocumentReference reference =
        firestore.collection("Tasker").doc(auth.userUid);

    try {
      await reference.set(userTask.toMap(auth.userUid));
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<UserTask> getUserTask() {
    try {
      return firestore
          .collection("Tasker")
          .doc(auth.userUid)
          .snapshots()
          .map((event) => UserTask.fromjson(event, auth.userUid));
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Task>> getTasks() {
    try {
      return firestore
          .collection("Tasker")
          .doc(auth.userUid)
          .collection("Tasks")
          .orderBy("dateTime",descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((document) {
          return Task.fromjson(document, document.id);
        }).toList();
      });
    } catch (e) {
      print("No data");
      return null;
    }
  }

  Future<void> updateTasks(Task task) async {
    CollectionReference reference =
        firestore.collection("Tasker").doc(auth.userUid).collection("Tasks");

    try {
      return await reference.doc(task.taskId).set(task.toMap(task.taskId));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(Task task, String id) async {
    CollectionReference reference =
        firestore.collection("Tasker").doc(auth.userUid).collection("Tasks");

    try {
      return await reference.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
