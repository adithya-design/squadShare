import 'package:flutter/material.dart';
import 'squad_icon.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
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
            ])),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SquadIcon(
            name: "Calisthenics",
            icon: Icon(Icons.fitness_center),
            color: Colors.red,
          ),
          SquadIcon(
            icon: Icon(Icons.music_note),
            name: "music",
            color: Colors.blue,
          ),
          SquadIcon(
            icon: Icon(Icons.run_circle),
            name: "yoga",
            color: Colors.green,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_outlined),
      ), 
    );
  }
}
