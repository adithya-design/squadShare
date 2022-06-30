import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squadfit_v0/authentication_service.dart';
import '../home_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                  await context.read<AuthenticationService>().signUp(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        username: usernameController.text.trim(),
                      );
                  print("email: " + emailController.text);
                  print("button pressed");
                  Navigator.pushNamed(context, 'ppUpload');
                },
                child: Text('Create'))
          ],
        ),
      ),
    );
  }
}
