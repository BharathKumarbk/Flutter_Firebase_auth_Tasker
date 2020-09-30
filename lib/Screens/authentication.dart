import 'package:firebase_flutter_todo/Models/user.dart';
import 'package:firebase_flutter_todo/Screens/home_page.dart';
import 'package:firebase_flutter_todo/Screens/login_signup.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Root extends StatelessWidget {
  saveUid(AppUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("userId", user.uid);
  }

  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<AppUser>(context);

    if (user != null) {
      saveUid(user);
      return HomePage();
    } else {
      return Authentication();
    }
  }
}
