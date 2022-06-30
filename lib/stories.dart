import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoreStories extends StatefulWidget {
  String SquadId;
  String usersmail;
  MoreStories({this.SquadId, this.usersmail});
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("More"),
        ),
        body: StreamBuilder(
            stream: db
                .collection('squads')
                .doc(widget.SquadId)
                .collection('status')
                .doc(widget.usersmail)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              List picsList = snapshot.data.get('pics');
              print(picsList);
              List<StoryItem> storyItems = [];
              print("users email :         " + widget.usersmail);
              for (var i = 0; i < picsList.length; i++) {
                StoryItem item = StoryItem.pageImage(
                    url: picsList[i], controller: storyController);
                storyItems.add(item);
              }

              if (!snapshot.hasData || !snapshot.data.exists) {
                return Center(child: CircularProgressIndicator());
              }
              int y = 9;
              return StoryView(
                storyItems: storyItems,
                //  [
                //   StoryItem.pageImage(
                //     url:
                //         "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                //     caption: "Still sampling",
                //     controller: storyController,
                //   ),
                //   StoryItem.pageImage(
                //     url:
                //         "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                //     caption: "Still sampling",
                //     controller: storyController,
                //   ),
                //   StoryItem.pageImage(
                //       url:
                //           "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                //       caption: "Working with gifs",
                //       controller: storyController),
                //   StoryItem.pageImage(
                //     url:
                //         "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
                //     caption: "Hello, from the other side",
                //     controller: storyController,
                //   ),
                //   StoryItem.pageImage(
                //     url:
                //         "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
                //     caption: "Hello, from the other side2",
                //     controller: storyController,
                //   ),
                // ],
                onStoryShow: (s) {
                  print("Showing a story");
                },
                onComplete: () {
                  print("Completed a cycle");
                  Navigator.pop(context);
                },
                progressPosition: ProgressPosition.top,
                repeat: false,
                controller: storyController,
              );
            }
            // body: StoryView(
            //   storyItems: [
            //     StoryItem.text(
            //       title: "I guess you'd love to see more of our food. That's great.",
            //       backgroundColor: Colors.blue,
            //     ),
            //     StoryItem.text(
            //       title: "Nice!\n\nTap to continue.",
            //       backgroundColor: Colors.red,
            //       textStyle: TextStyle(
            //         fontFamily: 'Dancing',
            //         fontSize: 40,
            //       ),
            //     ),
            //     StoryItem.pageImage(
            //       url:
            //           "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
            //       caption: "Still sampling",
            //       controller: storyController,
            //     ),
            //     StoryItem.pageImage(
            //         url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
            //         caption: "Working with gifs",
            //         controller: storyController),
            //     StoryItem.pageImage(
            //       url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            //       caption: "Hello, from the other side",
            //       controller: storyController,
            //     ),
            //     StoryItem.pageImage(
            //       url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            //       caption: "Hello, from the other side2",
            //       controller: storyController,
            //     ),
            //   ],
            //   onStoryShow: (s) {
            //     print("Showing a story");
            //   },
            //   onComplete: () {
            //     print("Completed a cycle");
            //     Navigator.pop(context);
            //   },
            //   progressPosition: ProgressPosition.top,
            //   repeat: false,
            //   controller: storyController,
            // ),
            ));
  }
}
