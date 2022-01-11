import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('squad fit'),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
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
          InkWell(
            child: Container(
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
              child: Text('Log in'))
        ],
      ),
    );
  }
}
