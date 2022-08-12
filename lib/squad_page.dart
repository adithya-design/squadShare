import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circular_widgets/circular_widgets.dart';
import 'package:squadfit_v0/home_page.dart';
import 'package:squadfit_v0/squadStatus.dart';
import 'package:squadfit_v0/squad_icon.dart';
import 'stories.dart';

class SquadPage extends StatefulWidget {
  SquadPage({Key key, this.squadID}) : super(key: key);

  String squadID;

  @override
  State<SquadPage> createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  int length = 4;
  String urltoRemove;

  //can be made constant.
  double innerSpacingDivider = 4;
  double radiusOfItemDivider = 1;
  double centerWidgetRadiusDivider = 3.5;

  double minnerSpacingDivider = 2;
  double mradiusOfItemDivider = 3;
  double mcenterWidgetRadiusDivider = 1;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db.collection('squads').doc(widget.squadID).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          print(snapshot.data.get('Squadname'));
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[900],
              title: Text(snapshot.data.get('Squadname')),
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Exit group"),
                      value: 1,
                      onTap: () async {
                        await db
                            .collection('USERS')
                            .where('email', isEqualTo: auth.currentUser.email)
                            .get()
                            .then((QuerySnapshot snapshot) => snapshot.docs
                                .where((QueryDocumentSnapshot
                                        queryDocumentSnapshot) =>
                                    urltoRemove =
                                        queryDocumentSnapshot.get("imgURL")));

// this removes the current users email from squads documnet
                        // await db
                        //     .collection('squads')
                        //     .doc(widget.squadID)
                        //     .update({
                        //   'members':
                        //       FieldValue.arrayRemove([auth.currentUser.email]),
                        //   'profilePics': FieldValue.arrayRemove([urltoRemove])
                        // });
                        Navigator.pop(context);
                      },
                    ),
                    PopupMenuItem(
                      child: Text("Add new member"),
                      value: 2,
                      onTap: () async {
                        if (auth.currentUser.email !=
                            snapshot.data.get('ownermail ')) {
                          final snakbar = SnackBar(
                              content: Text("Only the coach can add users"));
                          ScaffoldMessenger.of(context).showSnackBar(snakbar);
                          print('thing clicked"');
                        }
                      },
                    )
                  ],
                )
              ],
            ),
            body: Column(
              children: <Widget>[
                //Wrap with Expanded for Layout Builder to work, since it requires bounded width and height
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var smallestBoundary =
                          min(constraints.maxHeight, constraints.maxWidth);
                      List li = snapshot.data.get('members');
                      int l = li.length;
                      return CircularWidgets(
                          itemsLength: l,
                          itemBuilder: (context, index) {
                            // Can be any widget, preferably a circle
                            return SingleCircle(
                              squadId: widget.squadID,
                              net: snapshot.data.get('profilePics'),
                              index: index,
                              list: snapshot.data.get('members'),
                              // txt: snapshot.data.get('Squadname'),
                              color: Colors.grey,
                            );
                            //
                          },
                          innerSpacing: 80,
                          //  smallestBoundary / innerSpacingDivider,
                          radiusOfItem: 70,
                          centerWidgetRadius:
                              smallestBoundary / centerWidgetRadiusDivider,
                          centerWidgetBuilder: (context) {
                            // owner cirlce

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  primary: Colors.grey[900],
                                  padding: EdgeInsets.all(10)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Status(
                                            squadID: snapshot.data.id,
                                          )),
                                );
                              },
                              child: Icon(
                                Icons.circle,
                              ),
                            );
                          }
                          //   return BigCirlce(
                          //     squadId: widget.squadID,
                          //     owneremail: snapshot.data.get('ownermail '),
                          //     imgOwner: snapshot.data.get('ownerimg'),
                          //   );
                          // },
                          );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

// class BigCirlce extends StatelessWidget {
//   BigCirlce()
//       // {Key key,
//       // @required this.squadId,
//       // @required this.owneremail,
//       // @required this.imgOwner})
//   //     : super(key: key);
//   // final String squadId;
//   // final String owneremail;
//   // final FirebaseFirestore db = FirebaseFirestore.instance;
//   // dynamic imgOwner;

//   // @override
//   // Widget build(BuildContext context) {
//   //   return InkWell(
//   //     onTap: () {
//   //       db
//   //           .collection('squads')
//   //           .doc(squadId)
//   //           .collection('status')
//   //           .doc(owneremail)
//   //           .get()
//   //           .then((DocumentSnapshot documentSnapshot) {
//   //         if (documentSnapshot.exists) {
//   //           Navigator.push(
//   //             context,
//   //             MaterialPageRoute(
//   //               builder: (context) => MoreStories(
//   //                 SquadId: squadId,
//   //                 usersmail: owneremail,
//   //               ),
//   //             ),
//   //           );
//   //         } else {
//   //           final snakbar = SnackBar(content: Text("not uploaded yet"));
//   //           ScaffoldMessenger.of(context).showSnackBar(snakbar);
//   //           print("user has not uploaded yet");
//   //         }
//   //       });
//   //     },
//   //     child: CircleAvatar(
//   //       backgroundImage: NetworkImage(imgOwner),
//   //     ),
//   //   );
//   // }
// }

class SingleCircle extends StatelessWidget {
  // final String txt;
  final String squadId;

  final Color color;
  final List list;
  final int index;
  final List net;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  SingleCircle({
    Key key,
    // @required this.txt,
    @required this.squadId,
    @required this.color,
    @required this.list,
    @required this.index,
    @required this.net,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        db
            .collection('squads')
            .doc(squadId)
            .collection('status')
            .doc(list[index])
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoreStories(
                  SquadId: squadId,
                  usersmail: list[index],
                ),
              ),
            );
            print('this is index        ' + index.toString());
            print('users mail :           ' + list[index]);
          } else {
            final snakbar = SnackBar(content: Text("not uploaded yet"));
            ScaffoldMessenger.of(context).showSnackBar(snakbar);
            print("user has not uploaded yet");
          }
        });
      },
      child: CircleAvatar(
        backgroundImage: NetworkImage(net[index]),
      ),
    );
  }
}
