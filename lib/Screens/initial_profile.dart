import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_flutter_todo/Components/constants.dart';
import 'package:firebase_flutter_todo/Components/final.dart';
import 'package:firebase_flutter_todo/Models/user.dart';
import 'package:firebase_flutter_todo/Models/user_tasks.dart';
import 'package:firebase_flutter_todo/Services/firebase_image_storage.dart';
import 'package:firebase_flutter_todo/Services/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class InitialProfile extends StatefulWidget {
  @override
  _InitialProfileState createState() => _InitialProfileState();
}

class _InitialProfileState extends State<InitialProfile> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  File image;
  final picker = ImagePicker();
  bool uploadImage = false;

  Future getImage(bool isCamera) async {
    if (isCamera == true) {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {
          print("No image selected");
        }
      });
    } else {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);

          print(image.toString());
        } else {
          print("No image selected");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppUser user = Provider.of<AppUser>(context);

    final FirebaseImage firebaseImage = Provider.of<FirebaseImage>(context);
    final FirestoreStorage firestoreStorage =
        Provider.of<FirestoreStorage>(context);

    return Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Set Profile",
            style: googleMont.copyWith(
                fontSize: 34.0,
                fontWeight: FontWeight.bold,
                color: kBlackColor),
          ),
          backgroundColor: kWhiteColor,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              Center(
                child: new Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: new BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: new DecorationImage(
                      image: image == null
                          ? CachedNetworkImageProvider(
                              "https://i.pinimg.com/originals/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.png")
                          : FileImage(image),
                      fit: BoxFit.cover,
                    ),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(100.0)),
                    border: new Border.all(
                      color: kBlackColor,
                      width: 4.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: "camera",
                        child: Icon(
                          Icons.camera,
                          color: kWhiteColor,
                        ),
                        backgroundColor: kBlackColor,
                        onPressed: () {
                          getImage(true);
                        },
                      ),
                      FloatingActionButton(
                        heroTag: "gallery",
                        child: Icon(
                          Icons.photo_library,
                          color: kWhiteColor,
                        ),
                        backgroundColor: kBlackColor,
                        onPressed: () {
                          getImage(false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Fiels should not be empty";
                              } else {
                                return null;
                              }
                            },
                            controller: nameController,
                            decoration: inputDecoration.copyWith(
                              hintText: "Username ( eg. Bharath Kumar )",
                            )),
                      ),
                      isLoading
                          ? CircularProgressIndicator()
                          : FlatButton(
                              color: kButtonColor,
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                if (image != null) {
                                  firebaseImage
                                      .uploadFile(
                                          image, DateTime.now().toString())
                                      .then((value) {
                                    firestoreStorage
                                        .addUserCred(UserTask(
                                            userId: user.uid,
                                            userName: nameController.text,
                                            userImage: firebaseImage.url != null
                                                ? firebaseImage.url
                                                : image,
                                            userMail: user.email,
                                            imageName:
                                                firebaseImage.fileName != null
                                                    ? firebaseImage.fileName
                                                    : null))
                                        .then((value) =>
                                            Navigator.of(context).pop());
                                  });
                                }
                              },
                              child: Text(
                                "Submit",
                                style: googleMont.copyWith(
                                    color: kWhiteColor, fontSize: 16.0),
                              ),
                            ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
