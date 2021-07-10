import 'package:billtracker/screens/home.dart';
import 'package:billtracker/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({Key key}) : super(key: key);

  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.cyan,
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 10.0),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 5.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  hintText: "Email here ... ",
                ),
                controller: emailController,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  hintText: "Password here ... ",
                ),
                controller: passController,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  hintText: "Confirm Password here ... ",
                ),
                controller: confPassController,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
              child: TextButton(
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: () {
                  if (emailController.text == "" ||
                      emailController.text == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Email field is empty ... "),
                      ),
                    );
                    return;
                  }

                  if (passController.text == "" ||
                      passController.text == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Password field is empty ... "),
                      ),
                    );
                    return;
                  }

                  if (confPassController.text == "" ||
                      confPassController.text == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Confirm Password field is empty ... "),
                      ),
                    );
                    return;
                  }

                  if (confPassController.text != passController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Passwords don't match ... "),
                      ),
                    );
                    return;
                  }

                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passController.text)
                      .then(
                    (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Signed up successfully ... "),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                  ).onError(
                    (error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.message),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
