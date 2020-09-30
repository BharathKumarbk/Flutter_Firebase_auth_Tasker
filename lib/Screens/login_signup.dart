import 'package:firebase_flutter_todo/Components/constants.dart';
import 'package:firebase_flutter_todo/Components/final.dart';
import 'package:firebase_flutter_todo/Services/firebase_auth.dart';
import 'package:firebase_flutter_todo/Screens/initial_profile.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication>
    with TickerProviderStateMixin {
  bool asAccount = true;
  Animation animation;
  AnimationController animationController;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
  void initState() {
    animate();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final Auth auth = Provider.of<Auth>(context);

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Transform(
            transform:
                Matrix4.translationValues(animation.value * width, 0.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    asAccount == true
                        ? Image.asset("assets/images/login.png")
                        : Image.asset("assets/images/signup.png"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                            text: asAccount == true ? "LOGIN" : "SIGNUP",
                            style: googleMont.copyWith(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w900,
                                color: kBlackColor),
                            children: [
                              TextSpan(
                                text: ".",
                                style: googleMont.copyWith(
                                    fontSize: 45.0, color: kButtonColor),
                              )
                            ]),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                              controller: userNameController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Fiels should not be empty";
                                } else {
                                  return null;
                                }
                              },
                              decoration: inputDecoration.copyWith(
                                  hintText: "Username")),
                          TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Fiels should not be empty";
                                } else {
                                  return null;
                                }
                              },
                              obscureText: true,
                              decoration: inputDecoration.copyWith(
                                hintText: "Password",
                              )),
                          if (asAccount != true)
                            TextFormField(
                                controller: rePasswordController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Fiels should not be empty";
                                  } else if (value != passwordController.text) {
                                    return "Password did not match";
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: true,
                                decoration: inputDecoration.copyWith(
                                    hintText: "Retype Password")),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Consumer<Auth>(
                              builder: (context, child, widget) {
                                return FlatButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      if (asAccount == true) {
                                        return await auth
                                            .signInWithEmailAndPassword(
                                                userNameController.text,
                                                passwordController.text);
                                      } else {
                                        return await auth
                                            .createWithEmailAndPassword(
                                                userNameController.text,
                                                passwordController.text)
                                            .then((value) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                    InitialProfile()));
                                        });
                                      }
                                    }
                                  },
                                  color: kButtonColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Center(
                                    child: Text(
                                        asAccount == true
                                            ? "Log In"
                                            : "Sign Up",
                                        style: googleMont.copyWith(
                                            color: Colors.white,
                                            fontSize: 14.0)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                            text: asAccount == true
                                ? "Don't have an account ? "
                                : "Already have an account ? ",
                            style: googleMont.copyWith(
                                color: Colors.grey[800], fontSize: 12.0),
                            children: [
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        asAccount = !asAccount;
                                        animate();
                                      });
                                    },
                                  text: asAccount == true ? "Signup" : "Login",
                                  style: googleMont.copyWith(
                                      fontSize: 12.0, color: kButtonColor))
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
