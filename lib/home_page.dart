import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Create_New_Squad/newgroup_page.dart';
import 'squad_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_service.dart';
import 'package:provider/provider.dart';
import 'main.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.yellow[100],
          appBar: AppBar(
            title: Text(
              'SquadShare',
              style: TextStyle(color: Colors.green),
            ),
            actions: [
              PopupMenuButton(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            child: Text("Logout"),
                            value: 1,
                            onTap: () {
                              context.read<AuthenticationService>().signOut();
                              Navigator.pushNamed(context, '/Authenti');
                            })
                      ])
            ],
            // actions: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: Icon(Icons.more_vert),
            //   ),
            // ],
            backgroundColor: Colors.amber[300],
            foregroundColor: Colors.green,
            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.blur_circular), text: 'my squads'),
              Tab(
                icon: Icon(Icons.search_sharp),
                text: 'discover',
              )
            ]),
          ),
          body: TabBarView(children: [
            MySquads(),
            Icon(Icons.directions_transit),
          ]),
        ),
      ),
      routes: {
        '/newgroup': (context) => const ScaffoldPage(),
        '/Authenti': (context) => const AuthenticationWrapper(),
      },
    );
  }
}

class MySquads extends StatefulWidget {
  const MySquads({Key key}) : super(key: key);

  @override
  _MySquadsState createState() => _MySquadsState();
}

class _MySquadsState extends State<MySquads> {
  final db = FirebaseFirestore.instance;
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db
            .collection('squads')
            .where('members', arrayContains: userEMAIL())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          print(snapshot.data.docs);
          return Column(
            children: [
              Expanded(
                  child: ListView(
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((document) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SquadIcon(
                              color: Colors.amber[300],
                              icon: Icon(Icons.ac_unit),
                              name: document['Squadname'],
                            ));
                      }).toList())),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/newgroup');
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.add_outlined),
              ),
            ],
          );
        });
  }
}
