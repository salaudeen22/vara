import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:vara/utility/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vara/components/custom_textfield.dart';
import 'package:vara/components/primarybutton.dart';

class ActivityHelper extends StatefulWidget {
  const ActivityHelper({Key? key}) : super(key: key);

  @override
  _ActivityHelperState createState() => _ActivityHelperState();
}

class _ActivityHelperState extends State<ActivityHelper> {
  String? caption = '';
  String? description = '';
  String? location = '';
  File? imageFile;
  List<String> postImages = [];
  List<String> postImageUrls = [];
  List<String> postCaptions = ["women safety","women safety2","women safety3","women safety4","women safety5"];
  List<String> postDescriptions = [""];
  List<String> postLocations = ["bangalore","begur","chennai","mysore","pune","telagana","telagana","pune"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(child: Text('Vara Activity')),
        leading: Image.asset(
          "lib/images/logo.png",
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {
              selectPostImage(context);
            },
            icon: Icon(Icons.camera),
          ),
        ],
      ),
      body: feedBody(context),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAllPostData() ;

  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(

      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(18.0),
              topLeft: Radius.circular(18.0),
            ),
          ),
          child: ListView.builder(
            itemCount: postImageUrls.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                getImageContainer(),
                  Container(
                    width: 640,
                    height: 480,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        image: NetworkImage(postImageUrls[index]),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(width: 8, color: Colors.black12),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      postCaptions[index],
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(postDescriptions[index]),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Location: ${postLocations[index]}",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }


  void selectPostImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.1,
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: primaryColor, // Change to your primaryColor
                    child: Text("Gallery"),
                    onPressed: () async {
                      Navigator.pop(context);
                      final XFile? pickedImage = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 50,
                      );
                      if (pickedImage != null) {
                        setState(() {
                          imageFile = File(pickedImage.path);
                        });
                        getImageContainer();
                      } else {
                        Fluttertoast.showToast(msg: "Please select an image");
                      }
                    },
                  ),
                  MaterialButton(
                    color: primaryColor,
                    child: Text("Camera"),
                    onPressed: () async {
                      Navigator.pop(context);
                      final XFile? pickedImage = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        imageQuality: 50,
                      );
                      if (pickedImage != null) {
                        setState(() {
                          imageFile = File(pickedImage.path);
                        });
                        getImageContainer();
                      } else {
                        Fluttertoast.showToast(msg: "Please select an image");
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getImageContainer() {

    if (imageFile != null) {
      return Column(
        children: [
          Container(
            width: 320,
            height: 240,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                image: FileImage(imageFile!),
                fit: BoxFit.cover,
              ),
              border: Border.all(width: 8, color: Colors.black12),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          SizedBox(height: 5),
          CustomTextField(
            controller: TextEditingController(text: caption),
            hintText: " Caption",
            onChanged: (text) {
              setState(() {
                caption = text;
              });
            },
            validate: (v) {
              if (v!.isEmpty) {
                return "please enter Caption";
              } else {
                return null;
              }
            },
          ),
          SizedBox(height: 5),
          CustomTextField(
            controller: TextEditingController(text: description),
            hintText: " Description",

            onChanged: (text) {
              setState(() {
                description =
                    text;
              });
            },
            validate: (v) {
              if (v!.isEmpty) {
                return "please enter Description";
              } else {
                return null;
              }
            },
          ),
          SizedBox(height: 5),
          CustomTextField(
            controller: TextEditingController(text: location),
            hintText: "Location",

            onChanged: (text) {
              setState(() {
                location = text;
              });
            },
            validate: (v) {
              if (v!.isEmpty) {
                return "please enter Location";
              } else {
                return null;
              }
            },
          ),
          PrimaryButton(title: "Submit", onPressed: () {
            uploadPost();
          })
        ],
      );
    } else {
      return Container();
    }
  }

  void uploadPost() async {
    if (imageFile == null) {
      Fluttertoast.showToast(msg: "Please select an image");
      return;
    }

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString());

    final UploadTask uploadTask = storageReference.putFile(imageFile!);

    await uploadTask.whenComplete(() async {
      final String downloadUrl = await storageReference.getDownloadURL();

      final Map<String, dynamic> post = {
        'caption': caption,
        'description': description,
        'location': location,
        'image_url': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('posts').add(post);

      Fluttertoast.showToast(msg: "Post uploaded successfully");

      // Clear the form
      setState(() {
        imageFile = null;
        caption = '';
        description = '';
        location = '';
      });
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "Error uploading post: $onError");
    });
  }

  Future<void> fetchAllPostData() async {
    try {
      final ListResult result =
      await FirebaseStorage.instance.ref('posts').listAll();

      for (final Reference ref in result.items) {
        final url = await ref.getDownloadURL();
        final metadata = await ref.getMetadata();

        setState(() {
          postImageUrls.add(url);

          postCaptions.add(metadata.customMetadata?['caption'] ?? '');

          postDescriptions.add(metadata.customMetadata?['description'] ?? '');
          postLocations.add(metadata.customMetadata?['location'] ?? '');


        });
      }
    } catch (e) {
      print("Error fetching post data: $e");
    }
  }
}

