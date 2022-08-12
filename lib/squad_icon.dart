import 'package:flutter/material.dart';
import 'package:squadfit_v0/squad_page.dart';

class SquadIcon extends StatelessWidget {
  final String name;
  final Icon icon;
  final Color color;
  final String id;

  const SquadIcon({this.name, this.icon, this.color, this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SquadPage(
                  squadID: id,
                ),
              ),
            ),
            child: Container(
                height: 200,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      name,
                      style: TextStyle(color: Colors.amber),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(25.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: color,
                            width: 14,
                          )),
                      child: icon,
                    ),
                  ],
                )),
          ),
          // SizedBox(height: 20),
          // Text(name),
        ],
      ),
    );
  }
}
