import 'dart:math';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final db = FirebaseFirestore.instance;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp(
      {String email, String password, String username}) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
            (value) => db.collection('USERS').doc(value.user.uid).set({
              'email': email,
              'username': username,
            }),
          );
      print('User Sign up was succesful');

      return "Signed up";
    } on FirebaseAuthException catch (e) {
      print("ahhhhhhhhhhhhhhhhhhhhhhhhhhh");
      print(e.message);
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
