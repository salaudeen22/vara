import 'package:flutter/material.dart';
import 'package:vara/components/custom_textfield.dart';
import 'package:vara/components/primarybutton.dart';
import 'package:vara/utility/constants.dart';
import 'package:vara/components/secondarybutton.dart';
import 'package:vara/child/register_child.dart';
import 'package:vara/child/bottom_screen/child_home_screen.dart';
import 'package:vara/parent/register_parent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vara/db/shared_pref.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool isLoading = false;

  void onSubmit() async {
    _formKey.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _formData['email'].toString(),
        password: _formData['password'].toString(),
      );
      if (userCredential.user != null) {
        setState(() {
          isLoading = false;
        });

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then((value) => {
                  if (value['type'] == 'parent')
                    {
                      MySharedPrefences.saveUserType('parent'),
                      print(value['type']),
                      goto(context, HomeScreen())
                    }
                  else
                    {
                      MySharedPrefences.saveUserType('child'),
                      goto(context, HomeScreen())
                    }
                });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        dialgoue(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        dialgoue(context, 'Wrong password provided for that user.');
      }
    }
    print(_formData['email']);
    print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              isLoading
                  ? Progressindicator(context)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "User Login",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                Expanded(
                                    // Wrap the Column in Expanded
                                    child: Container(
                                        child: Image.asset(
                                  "lib/images/logo.png",
                                  width: 250,
                                  height: 200,
                                ))),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomTextField(
                                    hintText: "Enter mail",
                                    prefix: Icon(Icons.person),
                                    textInputAction: TextInputAction.next,
                                    keyboardtype: TextInputType.emailAddress,
                                    validate: (email) {
                                      if (email!.isEmpty ||
                                          email.length < 3 ||
                                          !email.contains("@")) {
                                        return "Enter correct email";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onsave: (email) {
                                      _formData['email'] = email ?? "";
                                    },
                                  ),
                                  CustomTextField(
                                    hintText: "Enter Password",
                                    isPassword: isPasswordShown,
                                    prefix: Icon(Icons.vpn_key_rounded),
                                    suffix: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordShown = !isPasswordShown;
                                        });
                                      },
                                      icon: Icon(isPasswordShown
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    validate: (password) {
                                      if (password!.isEmpty ||
                                          password.length < 7) {
                                        return "Enter correct password";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onsave: (password) {
                                      _formData['password'] = password ?? "";
                                    },
                                  ),
                                  PrimaryButton(
                                    title: "Login",
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        onSubmit();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Forgot password",
                                    style: TextStyle(fontSize: 18)),
                                SecondaryButton(
                                    title: "Click here", onPressed: () {}),
                              ],
                            ),
                          ),
                          SecondaryButton(
                            title: "Register As Child",
                            onPressed: () {
                              goto(context, RegisterChild());
                            },
                          ),
                          SecondaryButton(
                            title: "Register As Parent",
                            onPressed: () {
                              goto(context, RegisterParent());
                            },
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
