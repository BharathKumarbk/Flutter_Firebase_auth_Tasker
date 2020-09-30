import 'package:firebase_flutter_todo/Components/constants.dart';
import 'package:firebase_flutter_todo/Components/final.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDark,
      appBar: AppBar(
        title: Text(
          "About",
          style: googleMont.copyWith(
              fontSize: 34.0, fontWeight: FontWeight.bold, color: kWhiteColor),
        ),
        backgroundColor: kDark,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100.0,
              backgroundImage: AssetImage("assets/images/dev.png"),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              "Created by",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.white70),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: Colors.white12,
                height: 2.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            FittedBox(
              child: Text(
                "Bharath Kumar.B",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
