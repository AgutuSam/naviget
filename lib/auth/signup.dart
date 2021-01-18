import 'package:flutter/material.dart';
import 'package:naviget/auth/signin.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPass = TextEditingController();

  @override
  void initState() {
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
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFF004BE2),
                    image: DecorationImage(
                        image: AssetImage('assets/galaxypink.png'),
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
                    padding: const EdgeInsets.only(top: 0.0),
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
                                    Text("Sign Up",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28.0)),
                                    Card(
                                      margin: EdgeInsets.only(
                                          left: 30, right: 30, top: 10),
                                      elevation: 11,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      child: TextFormField(
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0)),
                                      ),
                                    ),
                                    Card(
                                      margin: EdgeInsets.only(
                                          left: 30, right: 30, top: 10),
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0)),
                                        obscureText: true,
                                      ),
                                    ),
                                    Card(
                                      margin: EdgeInsets.only(
                                          left: 30, right: 30, top: 10),
                                      elevation: 11,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      child: TextFormField(
                                        controller: confirmPass,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'This field cannot be Null!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              color: Color(0xFF0000E2),
                                            ),
                                            hintText: "Confirm Password",
                                            hintStyle: TextStyle(
                                              color: Color(0xFF0000E2),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0)),
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
                                          bottom: 5.0),
                                      child: RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        color: Color(0xFF0000C9),
                                        onPressed: () {
                                          if (password.text !=
                                              confirmPass.text) {
                                            Toast.show(
                                                'Passwords do not match!',
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          } else {
                                            signup(email.text, password.text);
                                            Toast.show(
                                                'A verification Link has been sent to your Email!',
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          }
                                        },
                                        elevation: 11,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0))),
                                        child: Text("Sign Up",
                                            style: TextStyle(
                                                color: Colors.white70)),
                                      ),
                                    ),
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
                height: 60,
              ),
              SafeArea(
                child: Visibility(
                  visible: MediaQuery.of(context).viewInsets.bottom == 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Already have an account?",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0)),
                            FlatButton(
                              child: Text("Sign In",
                                  style: TextStyle(
                                      color: Color(0xFF004BE2),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0)),
                              textColor: Colors.indigo,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignIn(),
                                        fullscreenDialog: true));
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //EmailPassword Sign
  Future<void> signup(String email, String password) async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      try {
        AuthResult res = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        res.user.sendEmailVerification();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
