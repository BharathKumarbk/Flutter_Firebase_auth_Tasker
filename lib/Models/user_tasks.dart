import 'package:cloud_firestore/cloud_firestore.dart';

class UserTask {
  final String userId;
  final String userName;
  final String userImage;
  final String userMail;
  final String imageName;

  UserTask({
    this.userId,
    this.userName,
    this.userImage,
    this.userMail,
    this.imageName,
  });

  factory UserTask.fromjson(DocumentSnapshot userData, String id) {
    return UserTask(
      userId: id,
      userName: userData.data()["userName"],
      userImage: userData.data()["userImage"],
      userMail: userData.data()["userMail"],
      imageName: userData.data()["imageName"],
    );
  }

  Map<String, dynamic> toMap(String id) {
    return {
      "userId": id,
      "userName": userName,
      "userImage": userImage,
      "userMail": userMail,
      "imageName": imageName,
    };
  }
}

class UploadImage {
  final String imageUrl;

  UploadImage({this.imageUrl});
}
