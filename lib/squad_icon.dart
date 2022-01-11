import 'package:flutter/material.dart';

class SquadIcon extends StatelessWidget {
  final String name;
  final Icon icon;
  final Color color;

  const SquadIcon({this.name, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 70),
          Container(
            padding: EdgeInsets.all(75.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 5,
                )),
            child: icon,
          ),
          SizedBox(height: 20),
          Text(name),
        ],
      ),
    );
  }
}
