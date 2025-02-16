import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore based on the current user
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _emailController.text = user.email ?? ''; // Ensure email is set first
      });

      try {
        // Retrieve user data from Firestore based on email
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email) // Make sure this email exists in Firestore
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = querySnapshot.docs.first;

          // Set other text controllers with Firestore data
          setState(() {
            _usernameController.text = userDoc['username'] ?? '';
            _phoneController.text = userDoc['phone number']?.toString() ?? '';

          });
        } else {
          print("User document not found in Firestore.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }



  // Sign out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "CONTACT SELLER",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(58, 77, 45, 1.0), // marketplaceTitle
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(167, 193, 149, 1.0), // topBarLeftGradient
                Color.fromRGBO(100, 133, 78, 1.0),  // topBarRightGradient
              ],
            ),
          ),
        ),

      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(height: 30),

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Username",
                    prefixIcon: Icon(
                      Icons.person_rounded,
                      color: Colors.lightGreen,
                    ),
                    hintStyle: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  enabled: false, // Making it read-only
                ),
                SizedBox(height: 15),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Your email",
                    prefixIcon: Icon(
                      Icons.email_rounded,
                      color: Colors.lightGreen,
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  enabled: false, // Making it read-only
                ),

                SizedBox(height: 15),

                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Your phone number",
                    prefixIcon: Icon(
                      Icons.phone_rounded,
                      color: Colors.lightGreen,
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  enabled: false, // Making it read-only
                ),

                SizedBox(height: 15),


              ],
            ),
          ),
        ],
      ),
    );
  }
}
