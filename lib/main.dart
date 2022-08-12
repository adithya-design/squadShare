import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squadfit_v0/authentication_service.dart';
import 'package:squadfit_v0/home_page.dart';
import 'package:squadfit_v0/sign_in.dart';
import 'uploaPP.dart';
import '../Create_New_Squad/newgroup_page.dart';
import 'sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SquadApp());
}

class SquadApp extends StatelessWidget {
  const SquadApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: null),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthenticationWrapper(),
          '/sign in': (context) => const Signin(),
          '/signup': (context) => Signup(),
          'home': (context) => const HomePage(),
          'ppUpload': (context) => const UserinfoPage(),
          '/newgroup': (context) => const ScaffoldPage(),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return HomePage();
    }
    return FirstPage();
  }
}

//Sign in or sing up page
class FirstPage extends StatefulWidget {
  const FirstPage({Key key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'squadshare',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 50),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  // boxShadow: BoxShadow(),
                  border: Border.all(
                      color: Color.fromARGB(255, 68, 68, 67),
                      style: BorderStyle.solid,
                      width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(255, 26, 26, 26),
                ),
                width: 250,
                height: 50,
                child: Center(
                    child: Text(
                  "Sign in",
                  style: TextStyle(color: Colors.white),
                )),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/sign in');
              },
            ),
            SizedBox(height: 10),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 68, 68, 67),
                      style: BorderStyle.solid,
                      width: 2.5),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromARGB(255, 26, 26, 26),
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
