import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squadfit_v0/authentication_service.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  File image;
  final ImagePicker _picker = ImagePicker();
  String imageURL;
  String emailText;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('fialed to pick image: $e');
    }
  }

  Future uploader() async {
    emailText = emailController.text.trim();

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/$emailText')
          .putFile(image);
      print("Uploadded");
      await downloadURLExample();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> downloadURLExample() async {
    emailText = emailController.text.trim();
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('uploads/$emailText')
        .getDownloadURL();

    setState(() {
      imageURL = downloadURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: image != null
                  ? ClipOval(
                      child: Image.file(
                        image,
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: 160,
                      height: 160,
                      child: Icon(Icons.camera_alt),
                    ),
            ),
            ElevatedButton.icon(
                onPressed: () {
                  pickImage();
                },
                icon: Icon(Icons.camera_alt_rounded),
                label: Text('upload profile pic')),
            InkWell(
              child: Container(
                width: 250,
                height: 50,
                child: Center(
                    child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "email",
                  ),
                )),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              height: 50,
              child: Center(
                  child: TextField(
                controller: passwordController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "password",
                ),
              )),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 250,
              height: 50,
              child: Center(
                  child: TextField(
                controller: usernameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "username",
                ),
              )),
            ),
            ElevatedButton(
                onPressed: () async {
                  await uploader();
                  context.read<AuthenticationService>().signUp(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        username: usernameController.text.trim(),
                        imgURL: imageURL,
                      );
                  print(imageURL);
                  print(emailController.text);
                  print("button pressed");
                  Navigator.popAndPushNamed(context, 'home');
                },
                child: Text('Next'))
          ],
        ),
      ),
    );
  }
}
