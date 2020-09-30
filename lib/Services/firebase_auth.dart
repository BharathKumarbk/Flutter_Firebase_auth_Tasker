import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_todo/Models/user.dart';
import 'package:flutter/foundation.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String get userUid => _firebaseAuth.currentUser.uid;

  Stream<AppUser> get user {
    return _firebaseAuth.authStateChanges().map((User user) {
      try {
        if (user.uid != null) {
          return AppUser(uid: user.uid,email: user.email);
        } else {
          return null;
        }
      } catch (e) {
        rethrow;
      }
    });
  }

  Future<void> createWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
