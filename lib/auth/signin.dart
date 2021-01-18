import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naviget/auth/auth.dart';
import 'package:naviget/auth/signup.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SignIn extends StatefulWidget {
  SignIn({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _prformKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordResetEmail = TextEditingController();
  bool otherSignIn;

  @override
  void initState() {
    otherSignIn = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  image: DecorationImage(
                      image: AssetImage('assets/hands.jpg'),
                      fit: BoxFit.cover)),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.black.withOpacity(0.5),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: Container(
                              height: height * 0.54,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Sign In",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28.0)),
                                  Card(
                                    margin: EdgeInsets.only(
                                        left: 30, right: 30, top: 30),
                                    elevation: 11,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: TextFormField(
                                      onTap: () {
                                        setState(() {
                                          otherSignIn = false;
                                        });
                                      },
                                      controller: email,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Email cannot be Null!';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: Colors.orange.shade400,
                                          ),
                                          suffixIcon: Icon(
                                            Icons.check_circle,
                                            color: Colors.orange.shade400,
                                          ),
                                          hintText: "Email",
                                          hintStyle: TextStyle(
                                              color: Colors.orange.shade400),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20.0,
                                              vertical: 16.0)),
                                    ),
                                  ),
                                  Card(
                                    margin: EdgeInsets.only(
                                        left: 30, right: 30, top: 20),
                                    elevation: 11,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: TextFormField(
                                      controller: password,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'password cannot be Null!';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.orange.shade400,
                                          ),
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                            color: Colors.orange.shade400,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20.0,
                                              vertical: 16.0)),
                                      obscureText: true,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(
                                        left: 30.0,
                                        right: 30.0,
                                        top: 15.0,
                                        bottom: 10.0),
                                    child: RaisedButton(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.0),
                                      color: Colors.orange.shade500,
                                      onPressed: () =>
                                          signin(email.text, password.text),
                                      elevation: 11,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),
                                      child: Text("Sign In",
                                          style:
                                              TextStyle(color: Colors.white70)),
                                    ),
                                  ),
                                  FlatButton(
                                      onPressed: () => forgotPassword(),
                                      child: Text("Forgot your password?",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0)))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            SafeArea(
                child: Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("or, connect with",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: width * 0.4,
                          child: RaisedButton.icon(
                            onPressed: () => signInWithGoogle(),
                            color: Colors.red,
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            icon: Icon(
                              FontAwesomeIcons.google,
                              color: Colors.white70,
                            ),
                            label: Text(
                              "Google",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(width: 10.0),
                        ButtonTheme(
                          minWidth: width * 0.4,
                          child: RaisedButton.icon(
                            onPressed: () => signInWithFacebook(),
                            color: Colors.indigo,
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            icon: Icon(
                              FontAwesomeIcons.facebookF,
                              color: Colors.white70,
                            ),
                            label: Text(
                              "Facebook",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Dont have an account?",
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0)),
                        FlatButton(
                          child: Text("Sign Up",
                              style: TextStyle(
                                  color: Colors.orange.shade100,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0)),
                          textColor: Colors.indigo,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                    fullscreenDialog: true));
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

//Forgot password
  Future forgotPassword() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: _prformKey,
            child: AlertDialog(
              title: Text('Email'),
              content: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Email cannot be Null!';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.blue),
                controller: passwordResetEmail,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.blue.shade500),
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () async {
                    final formState = _prformKey.currentState;
                    if (formState.validate()) {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: passwordResetEmail.text);
                        Navigator.pop(context);
                        Toast.show(
                            'A Password Reset Link has been sent to your Email!',
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM);
                      } catch (e) {
                        Toast.show(e.message, context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        print(e.message);
                      }
                    }
                  },
                  child: Text('Submit',
                      style: TextStyle(color: Colors.blue, fontSize: 22)),
                  elevation: 5.0,
                ),
              ],
            ),
          );
        });
  }

//EmailPassword Sign
  void signin(String email, String password) async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      try {
        FirebaseUser user = await widget.auth
            .signInWithFireBaseAuth(email: email, password: password);
        print(user.uid);
        widget.onSignedIn();
        CircularProgressIndicator();
      } catch (e) {
        Toast.show(e.message, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print(e.message);
      }
    }
  }

  //Google Sign
  void signInWithGoogle() async {
    try {
      FirebaseUser user = await widget.auth.signInWithGoogle();
      print(user.uid);
      widget.onSignedIn();
      CircularProgressIndicator();
    } catch (e) {
      Toast.show(e.message, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print(e.message);
    }
  }

  //Facebook
  void signInWithFacebook() async {
    try {
      FirebaseUser user = await widget.auth.signInWithFacebook();
      print(user.uid);
      widget.onSignedIn();
      CircularProgressIndicator();
    } catch (e) {
      Toast.show(e.message, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print(e.message);
    }
  }
}
