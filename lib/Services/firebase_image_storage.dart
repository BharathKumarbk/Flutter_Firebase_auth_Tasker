import 'dart:io';

import 'package:firebase_flutter_todo/Models/user_tasks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseImage extends ChangeNotifier {
  StorageReference storageReference;
  String url;
  String fileName;
  String get imageName => fileName;

  String get imageUrl => url;

  Future deleteImage(String name) async {
    try {
      FirebaseStorage.instance.ref().child("Tasker/$name").delete();
    } catch (e) {
      rethrow;
    }
  }


  Future<UploadImage> uploadFile(File file, String title) async {
    try {
      storageReference = FirebaseStorage.instance.ref().child("Tasker/$title");
      final StorageUploadTask uploadTask = storageReference.putFile(file);
      final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
      url = await downloadUrl.ref.getDownloadURL();
      fileName = title;

      if (uploadTask.isComplete) {
        var imageUrl = url.toString();
        return UploadImage(
          imageUrl: imageUrl,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
