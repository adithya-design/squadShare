import 'package:flutter/material.dart';
import 'package:squadfit_v0/home_page.dart';
import 'package:squadfit_v0/signup.dart';
import 'login.dart';

void main() {
  runApp(SquadApp());
}

class SquadApp extends StatelessWidget {
  const SquadApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstPage(),
        '/signup': (context) => const Signup(),
        '/login': (context) => const LoginPage(),
        'home': (context) => const HomePage(),
      },
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Squad \n     Fit',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 90),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.blue,
                ),
                width: 250,
                height: 50,
                child: Center(
                    child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                )),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            SizedBox(height: 10),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.green,
                ),
                width: 250,
                height: 50,
                child: Center(
                    child:
                        Text('Sign Up', style: TextStyle(color: Colors.white))),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
            )
          ],
        ),
      ),
    );
  }
}
