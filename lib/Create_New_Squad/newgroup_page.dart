import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SquadModel {
  List _members = [];
  String squadName;

  SquadModel({this.squadName});

  List get getMembers => _members;

  void addMember(String member) {
    _members.add(member);
  }

  void removeMember(String mail) {
    _members.removeWhere((element) => element == mail);
  }

  // void removeMember() {
  //   _members.removeWhere((element) =>
  //       element ==
  //       {
  //         "email": docus['email'],
  //         'uid': docus.id,
  //       });
  // }
}

class ScaffoldPage extends StatelessWidget {
  const ScaffoldPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Column(
              children: [
                Text(
                  'New Group',
                  style: TextStyle(fontSize: 3),
                ),
                Text('Add Participants'),
              ],
            ),
          ],
        ),
      ),
      body: ListofUsers(),
    );
  }
}

class ListofUsers extends StatefulWidget {
  const ListofUsers({Key key}) : super(key: key);

  @override
  _ListofUsersState createState() => _ListofUsersState();
}

class _ListofUsersState extends State<ListofUsers> {
  final db = FirebaseFirestore.instance;
  TextEditingController nameControl = TextEditingController();
  SquadModel squadinfo = SquadModel();

  final FirebaseAuth auth = FirebaseAuth.instance;

  String userID() {
    final User user = auth.currentUser;
    final uid = user.uid;
    return uid;
  }

  String userEMAIL() {
    final User user = auth.currentUser;
    final umail = user.email;
    return umail;
  }

  get currentUserEmail async {
    return auth.currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.collection('USERS').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              SizedBox(
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 300,
                          child: TextField(
                            controller: nameControl,
                            decoration:
                                InputDecoration(hintText: 'Name  of squad'),
                          )),
                    ]),
              ),
              Expanded(
                child: ListView(
                    children: snapshot.data.docs.map((document) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: UserTiles(
                        useModel: squadinfo,
                        docu: document,
                      ));
                }).toList()),
              ),
              FloatingActionButton(
                  backgroundColor: Colors.green[300],
                  child: Icon(Icons.check),
                  onPressed: () {
                    squadinfo.addMember(userEMAIL());
                    try {
                      db.collection('squads').doc().set({
                        'Squadname': nameControl.text.trim(),
                        'ownerid ': userID(),
                        'ownermail ': userEMAIL(),
                        'members': squadinfo.getMembers
                      });
                    } catch (e) {
                      print(e);
                    }
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}

class UserTiles extends StatefulWidget {
  final QueryDocumentSnapshot<Object> docu;
  final SquadModel useModel;

  const UserTiles({Key key, this.docu, this.useModel}) : super(key: key);

  @override
  State<UserTiles> createState() => _UserTilesState();
}

class _UserTilesState extends State<UserTiles> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        widget.docu['email'],
      ),
      secondary: const Icon(Icons.supervised_user_circle),
      autofocus: false,
      activeColor: Colors.green,
      checkColor: Colors.white,
      selected: _checked,
      value: _checked,
      onChanged: (bool value) {
        setState(() {
          _checked = value;
        });
        if (value == true) {
          widget.useModel.addMember(widget.docu['email']);
        } else {
          widget.useModel.removeMember(widget.docu['email']);
        }
      },
    );
  }
}
