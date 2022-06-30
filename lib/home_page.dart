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
import 'uploaPP.dart';
import 'sign_in.dart';
import 'sign_up.dart';
import 'squad_page.dart';
import 'squadStatus.dart';
import 'stories.dart';
import 'package:carousel_slider/carousel_slider.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/newgroup');
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.orange[900],
            child: const Icon(Icons.add_outlined),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          backgroundColor: Color(000000),
          bottomNavigationBar: menu(),
          appBar: AppBar(
            title: Text(
              'SquadShare',
              style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                  color: Colors.orange[900]),
            ),
            actions: [
              PopupMenuButton(
                color: Colors.orange[900],
                itemBuilder: (context) => [
                  PopupMenuItem(
                      child: Text("Logout"),
                      value: 1,
                      onTap: () async {
                        print(' logout btn pressed');
                        await context.read<AuthenticationService>().signOut();
                        Navigator.popAndPushNamed(context, '/Authenti');
                      }),
                ],
              )
            ],
            backgroundColor: Colors.grey[900],
          ),
          body: TabBarView(children: [
            MySquads(),
            Icon(Icons.directions_transit),
            // ClientSquads(),
          ]),
        ),
      ),
      routes: {
        '/newgroup': (context) => const ScaffoldPage(),
        '/Authenti': (context) => const AuthenticationWrapper(),
        'ppUpload': (context) => const UserinfoPage(),
        '/sign in': (context) => const Signin(),
        '/signup': (context) => Signup(),
        'home': (context) => const HomePage(),
        'squadPage': (context) => SquadPage(),
        'status': (context) => Status(),
        'story': (context) => MoreStories(),
      },
    );
  }

  Widget menu() {
    return Container(
      color: Colors.grey[900],
      child: TabBar(
        labelColor: Colors.orange[900],
        unselectedLabelColor: Colors.orange.shade800,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.blue,
        tabs: [
          Tab(
            icon: Icon(Icons.circle_outlined),
            // text: 'my squads'
          ),
          Tab(
            icon: Icon(Icons.search_sharp),
            // text: 'discover',
          ),
        ],
      ),
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
  int _current = 0;
  final CarouselController _controller = CarouselController();

  String userEMAIL() {
    final User user = auth.currentUser;
    //may be prob
    final umail = user.email;
    return umail;
  }

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Container(
    //     child: Text('fjh'),
    //   ),
    // );
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CarouselSlider(
                  items: snapshot.data.docs.map((document) {
                    return SquadIcon(
                      color: Colors.amber[300],
                      icon: Icon(Icons.ac_unit),
                      name: document['Squadname'],
                      id: document.id,
                    );
                  }).toList(),
                  carouselController: _controller,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      // aspectRatio: 3.5,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: snapshot.data.docs
                    .map((document) {
                      return SquadIcon(
                        color: Colors.amber[300],
                        icon: Icon(Icons.ac_unit),
                        name: document['Squadname'],
                        id: document.id,
                      );
                    })
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 7.0,
                          height: 15.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 7.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.white)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    })
                    .toList(),
              ),
              SizedBox(
                height: 40,
              )
              //     child: Center(
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 60.0),
              //     child: ListView(
              //         scrollDirection: Axis.horizontal,
              //         shrinkWrap: true,
              //         children: snapshot.data.docs.map((document) {
              //           return Padding(
              //               padding:
              //                   const EdgeInsets.symmetric(horizontal: 90),
              //               child: SquadIcon(
              //                 color: Colors.amber[300],
              //                 icon: Icon(Icons.ac_unit),
              //                 name: document['Squadname'],
              //                 id: document.id,
              //               ));
              //         }).toList()),
              //   ),
              // )),
            ],
          );
        });
  }
}

class ClientSquads extends StatefulWidget {
  const ClientSquads({Key key}) : super(key: key);

  @override
  _ClientSquadsState createState() => _ClientSquadsState();
}

class _ClientSquadsState extends State<ClientSquads> {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // String userID() {
  //   final User user = auth.currentUser;
  //   final uid = user.uid;
  //   return uid;
  // }

  String userEMAIL() {
    final User user = auth.currentUser;
    //may be prob
    final umail = user.email;
    return umail;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db
            .collection('squads')
            .where('ownermail ', isEqualTo: userEMAIL())
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
                              id: document.id,
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
