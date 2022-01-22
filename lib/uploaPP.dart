import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserinfoPage extends StatefulWidget {
  const UserinfoPage({Key key}) : super(key: key);

  @override
  _UserinfoPageState createState() => _UserinfoPageState();
}

class _UserinfoPageState extends State<UserinfoPage> {
  File image;
  final ImagePicker _picker = ImagePicker();
  FirebaseFirestore db = FirebaseFirestore.instance;

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

  // Future uploader() async{
  // firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('profile pics/');

  // String downloadURL = await reference.getDownloadURL();
  // await db.

  // }

  // Future uploadImage() async {
  //   try {
  //     final StorageReference storageReference = FirebaseStorage().ref().child("profilePicture");

  //     final StorageUploadTask uploadTask = storageReference.putFile(_image);

  //     final StreamSubscription<StorageTaskEvent> streamSubscription =
  //         uploadTask.events.listen((event) {
  //       // You can use this to notify yourself or your user in any kind of way.
  //       // For example: you could use the uploadTask.events stream in a StreamBuilder instead
  //       // to show your user what the current status is. In that case, you would not need to cancel any
  //       // subscription as StreamBuilder handles this automatically.

  //       // Here, every StorageTaskEvent concerning the upload is printed to the logs.
  //       print('EVENT ${event.type}');
  //     });

  //     // Cancel your subscription when done.
  //     await uploadTask.onComplete;
  //     streamSubscription.cancel();

  //     String imageUrl = await storageReference.getDownloadURL();
  //     await _firestore.collection("users").document("user1").setData({
  //       "profilePicture": imageUrl,
  //     });
  //   } catch (e) {
  //     print(e);
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
                  label: Text('upload profile pic')),
              SizedBox(height: 100),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'ppUpload');
                    Navigator.popAndPushNamed(context, 'home');
                    print("button pressed");
                  },
                  child: Text('Upload Profile picture'))
            ],
          ),
        ),
      ),
    );
  }
}
