import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/navigation_screen.dart';
import 'package:login/pages/login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // user is logged in
            if (snapshot.hasData) {
              return NavigationScreen();
            }

            // user is NOT logged in
            else {
              return LoginOrRegisterPage();
            }

    },
      ),
    );
  }
}




