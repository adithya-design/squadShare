import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';

class Signin extends StatefulWidget {
  const Signin({Key key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('squadshare'),
        backgroundColor: Color.fromARGB(255, 32, 32, 32),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   child: Flexible(
            //     fit: FlexFit.loose,
            //     child: Text(
            //       'squadshare ',
            //       style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontStyle: FontStyle.italic,
            //           fontSize: 40),
            //     ),
            //   ),
            // ),
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
                controller: emailController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "email",
                ),
              )),
            ),
            // Container(
            //   width: 250,
            //   height: 50,
            //   child: Center(
            //       child: TextField(
            //     keyboardType: TextInputType.number,
            //     decoration: InputDecoration(
            //       hintText: "username",
            //     ),
            //   )),
            // ),
            SizedBox(height: 10),
            Container(
              width: 250,
              height: 50,
              child: Center(
                  child: TextField(
                controller: passwordController,
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
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 32, 32, 32), // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () async {
                  await context.read<AuthenticationService>().signIn(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                  Navigator.pushNamed(context, 'home');
                },
                child: Text('sign in'))
          ],
        ),
      ),
    );
  }
}
