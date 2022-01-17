import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewGroupPage extends StatelessWidget {
  const NewGroupPage({Key key}) : super(key: key);

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
      body: Container(child: NewGRoupBody()),
    );
  }
}

class NewGRoupBody extends StatefulWidget {
  const NewGRoupBody({Key key}) : super(key: key);

  @override
  _NewGRoupBodyState createState() => _NewGRoupBodyState();
}

class _NewGRoupBodyState extends State<NewGRoupBody> {
  final db = FirebaseFirestore.instance;

  void _create() async {
    try {
      await db
          .collection('USERS')
          .doc()
          .set({'firstName': 'test', 'lastName': 'user'});
    } catch (e) {
      print(e);
    }
  }

  bool _checked = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.collection('USERS').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
              children: snapshot.data.docs.map((document) {
            return Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: UserTiles(
                      docu: document,
                    )),
              ],
            );
          }).toList());
        });
  }
}

class UserTiles extends StatefulWidget {
  final QueryDocumentSnapshot<Object> docu;

  const UserTiles({Key key, this.docu}) : super(key: key);

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
      },
    );
  }
}

class SearchUserTiles extends StatefulWidget {
  final String docName;

  const SearchUserTiles({Key key, this.docName}) : super(key: key);

  @override
  _SearchUserTilesState createState() => _SearchUserTilesState();
}

class _SearchUserTilesState extends State<SearchUserTiles> {
  bool check;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      activeColor: Colors.greenAccent,
      title: Text(widget.docName),
      value: check,
      onChanged: (bool value) {
        check = value;

        // add uid  and email to class

        //create new firebase collection called squads by tacking squadname from controller
        //and userid from doc and email.
      },
    );
  }
}
