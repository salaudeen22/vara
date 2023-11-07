import 'package:flutter/material.dart';
import 'package:vara/utility/constants.dart';
import 'package:vara/components/custom_textfield.dart';
import 'package:vara/components/primarybutton.dart';
import 'package:vara/components/secondarybutton.dart';
import 'package:vara/child/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vara/child/bottom_screen/child_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vara/model/user_model.dart';

class RegisterParent extends StatefulWidget {
  @override
  RegisterParentState createState() => RegisterParentState();
}

class RegisterParentState extends State<RegisterParent> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>(); // Corrected variable name
  final _formData = Map<String, Object>();
  bool isLoading=false;

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_formData['password'] != _formData['rpassword']) {
        dialgoue(context, "Password and Retype Password should match");
      } else {
        setState(() {
          isLoading = true;
        });

        try {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _formData['email'].toString(),
            password: _formData['password'].toString(),
          );

          if (userCredential.user != null) {
            final v = userCredential.user!.uid;
            DocumentReference<Map<String, dynamic>> db = FirebaseFirestore.instance.collection("users").doc(v);

            final user = UserModel(
              name: _formData['name'].toString(),
              phone: _formData['phone'].toString(),
              childEmail: _formData['cemail'].toString(),
              parentEmail: _formData['email'].toString(),
              id: v,
              type: 'parent',
            );

            final jsonData = user.toJson();

            await db.set(jsonData).whenComplete(() {
              goto(context, LoginScreen());
              setState(() {
                isLoading = false;
              });
            });
          }
        } on FirebaseAuthException catch (e) {
          setState(() {
            isLoading = false;
          });

          if (e.code == 'weak-password') {
            dialgoue(context, 'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            dialgoue(context, 'The account already exists for that email.');
          }
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          print(e);
        }

        print(_formData['email']);
        print(_formData['password']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [isLoading
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
                          "Register As Parent",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),  Expanded( // Wrap the Column in Expanded
                          child: Container(child:
                        Image.asset(
                          "lib/images/logo.png",
                          width: 250,
                          height: 200,
                        )
                          )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTextField(
                            hintText: "Enter Name",
                            prefix: Icon(Icons.person),
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.name,
                            validate: (name) {
                              if (name!.isEmpty || name.length < 3) {
                                return "Enter correct name";
                              } else {
                                return null;
                              }
                            },
                            onsave: (name) {
                              _formData['name'] = name ?? "";
                            },
                          ),
                          CustomTextField(
                            hintText: "Enter Phone Number",
                            prefix: Icon(Icons.phone),
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.phone,
                            validate: (phone) {
                              if (phone!.isEmpty || phone.length < 3) {
                                return "Enter correct name";
                              } else {
                                return null;
                              }
                            },
                            onsave: (phone) {
                              _formData['phone'] = phone ?? "";
                            },
                          ),
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
                            hintText: "Enter  Child mail",
                            prefix: Icon(Icons.group),
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.emailAddress,
                            validate: (cemail) {
                              if (cemail!.isEmpty ||
                                  cemail.length < 3 ||
                                  !cemail.contains("@")) {
                                return "Enter correct email";
                              } else {
                                return null;
                              }
                            },
                            onsave: (cemail) {
                              _formData['cemail'] = cemail ?? "";
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
                              if (password!.isEmpty || password.length < 7) {
                                return "Enter correct password";
                              } else {
                                return null;
                              }
                            },
                            onsave: (password) {
                              _formData['password'] = password ?? "";
                            },
                          ),
                          CustomTextField(
                            hintText: "Enter Retype Password",
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
                            validate: (rpassword) {
                              if (rpassword!.isEmpty || rpassword.length < 7) {
                                return "Enter correct password";
                              } else {
                                return null;
                              }
                            },
                            onsave: (rpassword) {
                              _formData['rpassword'] = rpassword ?? "";
                            },
                          ),
                          PrimaryButton(
                            title: "Register",
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
                  SecondaryButton(
                    title: "Login",
                    onPressed: () {
                      goto(context, LoginScreen());
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
