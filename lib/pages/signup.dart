import 'package:flutter/material.dart';
import 'package:zsquadfitness/services/auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up Page")),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to the Sign Up Page!"),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                AuthService().signInWithGoogle(context);
              },
              child: Container(
                height: 70,
                margin: EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/google.png',
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Logga in med Google',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
