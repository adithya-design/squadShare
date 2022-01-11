import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('squad fit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Flexible(
                fit: FlexFit.loose,
                child: Text(
                  'Squad \n     Fit ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 80),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                height: 15,
              ),
            ),
            Container(
              width: 250,
              height: 50,
              child: Center(
                  child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "phone number",
                ),
              )),
            ),
            Container(
              width: 250,
              height: 50,
              child: Center(
                  child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "username",
                ),
              )),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              height: 50,
              child: Center(
                  child: TextField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "password",
                ),
              )),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'home');
                },
                child: Text('sign up'))
          ],
        ),
      ),
    );
  }
}
