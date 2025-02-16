import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/pages/add.dart';
import 'package:login/pages/profile.dart';
import 'package:login/pages/trash_selection.dart';



class InboxPage extends StatefulWidget {
  const InboxPage ({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final screens = [
    TrashSelection(),
    AddPage(),
    ProfilePage(),
  ];

  // signUserOut method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Center(
          child: Text(
            "INBOX",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: signUserOut, // Call function to logout
            icon: Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),

    );
  }
}
