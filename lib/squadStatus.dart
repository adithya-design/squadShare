import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:squadfit_v0/home_page.dart';

class Status extends StatefulWidget {
  final String squadID;

  const Status({Key key, this.squadID}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  File image;
  final ImagePicker _picker = ImagePicker();
  String imageURL;
  String emailText;
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String userEMAIL() {
    final User user = auth.currentUser;

    final umail = user.email;
    return umail;
  }

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

  // this works
  Future uploader() async {
    emailText = auth.currentUser.email;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref("status")
        .child(widget.squadID)
        .child(emailText);
    try {
      await ref.putFile(image);

      await ref.getDownloadURL().then((value) {
        setState(() {
          imageURL = value;
        });
      });

      print(imageURL);

      print("Uploadded");
    } on FirebaseException catch (e) {
      print("failed to upload image :$e");
    }

    // await db.collection('USERDP').doc().set({
    //   'email': emailText,
    //   'imgURL': imageURL,
    // });

    int time = DateTime.now().microsecondsSinceEpoch;
    db
        .collection('squads')
        .doc(widget.squadID)
        .collection('status')
        .doc(userEMAIL())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (!documentSnapshot.exists) {
        await db
            .collection('squads')
            .doc(widget.squadID)
            .collection('status')
            .doc(userEMAIL())
            .set({
          "pics": FieldValue.arrayUnion([imageURL]),
        });
      }
      await db
          .collection('squads')
          .doc(widget.squadID)
          .collection('status')
          .doc(userEMAIL())
          .update({
        "pics": FieldValue.arrayUnion([imageURL]),
      });
    });

    // await db.collection('squads').doc(widget.squadID).collection('status').add({
    //   '$userEMAIL()': imageURL,
    // });
    // await db.collection('USERS').doc(auth.currentUser.uid).update({
    //   'imgURL': imageURL,

    // });
  }

  // Within your widgets:
  // Image.network(downloadURL);

  // File image;
  // final ImagePicker _picker = ImagePicker();
  // FirebaseFirestore db = FirebaseFirestore.instance;

  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;

  //     final imageTemporary = File(image.path);
  //     setState(() {
  //       this.image = imageTemporary;
  //     });
  //   } on PlatformException catch (e) {
  //     print('fialed to pick image: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                child: Flexible(
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
                          )),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    pickImage();
                  },
                  icon: Icon(Icons.camera_alt_rounded),
                  label: Text('pick a profile pic')),
              SizedBox(height: 100),
              ElevatedButton(
                  onPressed: () async {
                    await uploader();
                    print('this is the URL of the image$imageURL');

                    Navigator.pop(context);

                    print("upload profile pic btn pressed");
                  },
                  child: Text('Upload Profile picture'))
            ],
          ),
        ),
      ),
    );
  }
}
