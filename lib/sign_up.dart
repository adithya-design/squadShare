import 'package:flutter/material.dart';
import 'package:squadfit_v0/authentication_service.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatelessWidget {
  SigninPage({Key key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            InkWell(
              child: Container(
                width: 250,
                height: 50,
                child: Center(
                    child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "email",
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
                onPressed: () {
                  context.read<AuthenticationService>().signUp(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                  print(emailController.text);
                  print("button pressed");
                },
                child: Text('Sign Up'))
          ],
        ),
      ),
    );
  }
}
