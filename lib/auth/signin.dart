import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naviget/alert.dart';
import 'package:naviget/auth/auth.dart';
import 'package:naviget/auth/signup.dart';
import 'package:flare_flutter/flare_actor.dart';
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
  final databaseReference = FirebaseFirestore.instance;
  bool otherSignIn;
  bool loadState;

  @override
  void initState() {
    otherSignIn = true;
    loadState = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: height,
        width: MediaQuery.of(context).size.width > 1280 ? 414 : width,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Visibility(
                visible: loadState,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF004BE2).withOpacity(0.2),
                          image: DecorationImage(
                              image: AssetImage('assets/galaxynavy.png'),
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
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 2.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Form(
                                    key: _formKey,
                                    child: Container(
                                      height: height * 0.54,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    color: Color(0xFF0000E2),
                                                  ),
                                                  suffixIcon: Icon(
                                                    Icons.check_circle,
                                                    color: Color(0xFF0000E2),
                                                  ),
                                                  hintText: "Email",
                                                  hintStyle: TextStyle(
                                                      color: Color(0xFF0000E2)),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12.0)),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
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
                                                    color: Color(0xFF0000E2),
                                                  ),
                                                  hintText: "Password",
                                                  hintStyle: TextStyle(
                                                    color: Color(0xFF0000E2),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12.0)),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
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
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.0),
                                              color: Color(0xFF0000C9),
                                              onPressed: () => signin(
                                                  email.text, password.text),
                                              elevation: 11,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              12.0))),
                                              child: Text("Sign In",
                                                  style: TextStyle(
                                                      color: Colors.white70)),
                                            ),
                                          ),
                                          FlatButton(
                                              onPressed: () => forgotPassword(),
                                              child: Text(
                                                  "Forgot your password?",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ButtonTheme(
                                    minWidth:
                                        MediaQuery.of(context).size.width > 1280
                                            ? width * 0.24
                                            : width * 0.8,
                                    child: RaisedButton.icon(
                                      onPressed: () => signInWithGoogle(),
                                      color: Colors.red,
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
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
                                            color: Color(0xFF004BE2),
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
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !loadState,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF004BE2).withOpacity(0.2),
                        image: DecorationImage(
                            image: AssetImage('assets/grid.jpg'),
                            fit: BoxFit.cover)),
                    child: Center(
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: width * 0.5,
                              height: height * 0.5,
                              child: FlareActor(
                                'assets/naviloading.flr',
                                animation: 'Aura',
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BeautifulAlertDialog(
                                'A Password Reset Link has been sent to your Email!',
                              );
                            });
                      } catch (e) {
                        e.message != null
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BeautifulAlertDialog(e.message);
                                })
                            : print('e.message is null');
                        // print(e.message);
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
      setState(() {
        loadState = !loadState;
      });
      try {
        User user = await widget.auth
            .signInWithFireBaseAuth(email: email, password: password);
        print(user.uid);
        widget.onSignedIn();
      } catch (e) {
        e.message != null
            ? showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BeautifulAlertDialog(e.message);
                })
            : print('e.message is null');
        // print(e.message);
        setState(() {
          loadState = !loadState;
        });
      }
    }
  }

  //Google Sign
  void signInWithGoogle() async {
    try {
      setState(() {
        loadState = !loadState;
      });
      User user = await widget.auth.signInWithGoogle();

      print(user.uid);
      widget.onSignedIn();
    } catch (e) {
      setState(() {
        loadState = !loadState;
      });
      e.message != null
          ? showDialog(
              context: context,
              builder: (BuildContext context) {
                return BeautifulAlertDialog(e.message);
              })
          : setState(() {
              loadState = !loadState;
            });
      // print(e.message);
    }
  }

  // //Facebook
  // void signInWithFacebook() async {
  //   try {
  //     User user = await widget.auth.signInWithFacebook();
  //     print(user.uid);
  //     widget.onSignedIn();
  //     CircularProgressIndicator();
  //   } catch (e) {
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return BeautifulAlertDialog(e.message);
  //         });
  //     print(e.message);
  //   }
  // }
}
