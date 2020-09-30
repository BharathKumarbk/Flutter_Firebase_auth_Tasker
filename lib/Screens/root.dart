
import 'package:firebase_flutter_todo/Models/user.dart';
import 'package:firebase_flutter_todo/Screens/authentication.dart';
import 'package:firebase_flutter_todo/Services/firebase_auth.dart';
import 'package:firebase_flutter_todo/Services/firebase_image_storage.dart';
import 'package:firebase_flutter_todo/Services/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<AppUser>.value(
          value: Auth().user,
          catchError: (context, obj) {
            print(obj);
            return;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseImage(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirestoreStorage(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Root(),
      ),
    );
  }
}
