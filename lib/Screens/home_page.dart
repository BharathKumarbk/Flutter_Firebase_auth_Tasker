import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_flutter_todo/Components/constants.dart';
import 'package:firebase_flutter_todo/Components/drawer_details.dart';
import 'package:firebase_flutter_todo/Components/final.dart';
import 'package:firebase_flutter_todo/Components/task_card.dart';
import 'package:firebase_flutter_todo/Models/user_tasks.dart';

import 'package:firebase_flutter_todo/Screens/add_task.dart';
import 'package:firebase_flutter_todo/Services/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  @override
  void initState() {
    animate();
    super.initState();
  }

  animate() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.linearToEaseOut,
    ));
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final FirestoreStorage storage = Provider.of<FirestoreStorage>(context);
    return Scaffold(
      backgroundColor: kDark,
      appBar: AppBar(
        title: Text(
          "Tasker 1.1",
          style: googleMont.copyWith(
              fontSize: 34.0, fontWeight: FontWeight.bold, color: kWhiteColor),
        ),
        backgroundColor: kDark,
        elevation: 0.0,
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              setState(() {
                Scaffold.of(context).openDrawer();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: storage.getUserTask(),
                builder: (c, snapshot) {
                  UserTask data = snapshot.data;
                  if (snapshot.hasData) {
                    return CircleAvatar(
                      backgroundColor: kWhiteColor,
                      backgroundImage:
                          CachedNetworkImageProvider(data.userImage),
                    );
                  } else {
                    return Center(
                      child: Text("no data"),
                    );
                  }
                },
              ),
            ),
          );
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: kWhiteColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) => AddForm(
                            isUpdate: false,
                          )));
                }),
          )
        ],
      ),
      drawer: Drawer(
        child: DrawerDetails(),
      ),
      body: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform(
            transform:
                Matrix4.translationValues(animation.value * width, 0.0, 0.0),
            child: StreamBuilder(
              stream: storage.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                      itemCount: snapshot.data.length,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (c, i) {
                        return TaskGrid(
                          task: snapshot.data[i],
                        );
                      });
                } else {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 30.0,
                        ),
                        Text(
                          "Loading...",
                          style: googleMont.copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
