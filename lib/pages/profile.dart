import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/my_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Text controllers for form fields
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();

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
            _postcodeController.text = userDoc['postcode']?.toString() ?? '';
            _districtController.text = userDoc['district'] ?? '';
            _stateController.text = userDoc['state'] ?? '';
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


  // Function to update user data
  Future<void> updateUserRecord() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch the document that matches the user's email
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Update the existing document
          String docId = querySnapshot.docs.first.id; // Get document ID
          await FirebaseFirestore.instance.collection('users').doc(docId).update({
            'username': _usernameController.text,
            'phone number': _phoneController.text,
            'postcode': _postcodeController.text,
            'district': _districtController.text,
            'state': _stateController.text,
          });

        } else {
          // No document exists, so create a new record
          await FirebaseFirestore.instance.collection('users').add({
            'uid': user.uid,  // Store UID
            'email': user.email, // Store Email
            'username': _usernameController.text,
            'phone number': _phoneController.text,
            'postcode': _postcodeController.text,
            'district': _districtController.text,
            'state': _stateController.text,
          });

        }
      } catch (e) {
        showErrorMessage('Error updating profile: $e');
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              'Error',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "PROFILE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(58, 77, 45, 1.0), // marketplaceTitle
            ),
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
        actions: [
          IconButton(
            onPressed: signUserOut, // Call function to logout
            icon: Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(50),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.shade800, width: 10),
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("lib/images/profile.jpg"),
                    ),
                  ),
                ),
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 200, left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(height: 30),
                // Name
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    hintText: "Username",
                    prefixIcon: Icon(
                      Icons.person_rounded,
                      color: Colors.lightGreen,
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),

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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),

                ),
                SizedBox(height: 15),
                // Postcode
                TextFormField(
                  controller: _postcodeController,
                  decoration: InputDecoration(
                    labelText: "Postcode",
                    hintText: "Your postcode",
                    prefixIcon: Icon(
                      Icons.location_on_rounded,
                      color: Colors.lightGreen,
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),

                ),
                SizedBox(height: 15),
                // District
                TextFormField(
                  controller: _districtController,
                  decoration: InputDecoration(
                    labelText: "District",
                    hintText: "Your district",
                    prefixIcon: Icon(
                      Icons.location_city_rounded,
                      color: Colors.lightGreen,
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),

                ),
                SizedBox(height: 15),
                // State
                TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(
                    labelText: "State",
                    hintText: "Your state",
                    prefixIcon: Icon(
                      Icons.location_on_rounded,
                      color: Colors.lightGreen,
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10),),
                    ),
                  ),

                ),

                SizedBox(height: 20),
                MyButton(onTap: updateUserRecord, text: "Update")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
