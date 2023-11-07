import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class PostUploadForm extends StatefulWidget {
  @override
  _PostUploadFormState createState() => _PostUploadFormState();
}

class _PostUploadFormState extends State<PostUploadForm> {
  String caption = '';
  String description = '';
  String location = '';
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageFile != null)
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
        ElevatedButton(
          onPressed: () {
            selectImage();
          },
          child: Text('Select Image'),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: TextEditingController(text: caption),
          decoration: InputDecoration(labelText: 'Caption'),
          onChanged: (text) {
            setState(() {
              caption = text;
            });
          },
          validator: (v) {
            if (v!.isEmpty) {
              return "Please enter Caption";
            } else {
              return null;
            }
          },
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: TextEditingController(text: description),
          decoration: InputDecoration(labelText: 'Description'),
          onChanged: (text) {
            setState(() {
              description = text;
            });
          },
          validator: (v) {
            if (v!.isEmpty) {
              return "Please enter Description";
            } else {
              return null;
            }
          },
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: TextEditingController(text: location),
          decoration: InputDecoration(labelText: 'Location'),
          onChanged: (text) {
            setState(() {
              location = text;
            });
          },
          validator: (v) {
            if (v!.isEmpty) {
              return "Please enter Location";
            } else {
              return null;
            }
          },
        ),
        SizedBox(height: 5),
        ElevatedButton(
          onPressed: () {
            uploadPost();
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  Future<void> selectImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    } else {
      Fluttertoast.showToast(msg: "Please select an image");
    }
  }

  void uploadPost() async {
    if (imageFile == null) {
      Fluttertoast.showToast(msg: "Please select an image");
      return;
    }

    // Upload the image to Firebase Storage
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString());

    final UploadTask uploadTask = storageReference.putFile(imageFile!);

    try {
      await uploadTask.whenComplete(() async {
        final String downloadUrl = await storageReference.getDownloadURL();

        // Create a map with post data
        final Map<String, dynamic> post = {
          'caption': caption,
          'description': description,
          'location': location,
          'image_url': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        };

        // Upload the post data to Firebase Firestore
        await FirebaseFirestore.instance.collection('posts').add(post);

        // Display a success message
        Fluttertoast.showToast(msg: "Post uploaded successfully");

        // Clear the form
        setState(() {
          imageFile = null;
          caption = '';
          description = '';
          location = '';
        });
      });
    } catch (error) {
      // Handle any errors that occur during the upload
      print("Error uploading post: $error");
      Fluttertoast.showToast(msg: "Error uploading post: $error");
    }
  }
}