import 'package:flutter/material.dart';
import 'package:vara/utility/constants.dart';
import 'package:vara/components/custom_textfield.dart';
import 'package:vara/components/primarybutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameC = TextEditingController();
  String id = '';
  String? profilePic;
  String email='';
  String phone='';
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          nameC.text = snapshot['name'];
          id = snapshot.id;
          profilePic = snapshot['profilePic'];
          email=snapshot['childEmail'];
          phone=snapshot['phone'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSaving
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Update Your Profile",
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      final XFile? pickImage = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 50,
                      );
                      if (pickImage != null) {
                        setState(() {
                          profilePic = pickImage.path;
                        });
                      }
                    },
                    child: Container(
                      child: profilePic == null
                          ? CircleAvatar(
                        radius: 50,
                        child: Image.asset('images/avatarlogo.png'),
                      )
                          : profilePic!.contains('http')
                          ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profilePic!),
                      )
                          : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(profilePic!)),
                      ),
                    ),
                  ),
                  CustomTextField(
                    controller: nameC,
                    hintText: "Username",
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "Please enter your name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 25),
                  CustomTextField(
                    controller: TextEditingController(text: email),
                    hintText:"Email",
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "Please enter your email";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 25),
                  CustomTextField(
                    controller: TextEditingController(text: phone),
                    hintText: "Phone Number",
                    validate: (v)
                    {
                      if(v!.isEmpty)
                        {
                          return"please enter phone number";
                        }
                      else
                        {
                          return null;
                        }
                    },
                  ),
                  PrimaryButton(
                    title: "update",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        SystemChannels.textInput.invokeMethod<void>('TextInput.hide');

                        if (profilePic == null) {
                          Fluttertoast.showToast(msg: "Please select an image");
                        } else {
                          await update();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> update() async {
    setState(() {
      isSaving = true;
    });

    try {
      final downloadUrl = await uploadImage(profilePic!);
      final data = {
        'name': nameC.text,
        'profilePic': downloadUrl,
        'childEmail':email,
        'phone':phone,

      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);

      Fluttertoast.showToast(msg: "Profile updated successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred: $e");
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  Future<String> uploadImage(String filePath) async {
    final filename = Uuid().v4();
    final fbStorage = FirebaseStorage.instance.ref('profile').child(filename);
    final uploadTask = fbStorage.putFile(File(filePath));
    await uploadTask;
    return await fbStorage.getDownloadURL();
  }
}
