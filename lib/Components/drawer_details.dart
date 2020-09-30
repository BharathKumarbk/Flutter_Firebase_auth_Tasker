import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_flutter_todo/Components/constants.dart';
import 'package:firebase_flutter_todo/Components/final.dart';
import 'package:firebase_flutter_todo/Models/user_tasks.dart';
import 'package:firebase_flutter_todo/Screens/Splash_screen.dart';
import 'package:firebase_flutter_todo/Screens/profile_edit.dart';
import 'package:firebase_flutter_todo/Services/firebase_auth.dart';
import 'package:firebase_flutter_todo/Services/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerDetails extends StatefulWidget {
  @override
  _DrawerDetailsState createState() => _DrawerDetailsState();
}

class _DrawerDetailsState extends State<DrawerDetails> {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    final FirestoreStorage firestoreStorage =
        Provider.of<FirestoreStorage>(context);

    return Container(
      color: kDark,
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: firestoreStorage.getUserTask(),
                  builder: (c, snapshot) {
                    UserTask data = snapshot.data;
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Expanded(
                            child: FittedBox(
                                child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  CachedNetworkImageProvider(data.userImage),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data.userName ?? "User Name",
                              textAlign: TextAlign.center,
                              style: googleMont.copyWith(),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: Text("no data"),
                      );
                    }
                  },
                ),
              )),
          Container(
            height: 2.0,
            color: Colors.black12,
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfileEdit()));
                  },
                  leading: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Edit Profile",
                    style: googleMont.copyWith(fontSize: 20.0),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => About()));
                  },
                  leading: Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  title: Text(
                    "About",
                    style: googleMont.copyWith(fontSize: 20.0),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await auth.signOut();
                  },
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Log out",
                    style: googleMont.copyWith(fontSize: 20.0),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
