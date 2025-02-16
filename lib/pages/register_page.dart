import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/my_button.dart';
import 'package:login/components/my_textfield.dart';
import 'package:login/components/square_tile.dart';
import 'package:login/pages/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required  this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();


  // SignUserUp method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Check if any field is empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty ||
        _usernameController.text.isEmpty || _phoneController.text.isEmpty || _postcodeController.text.isEmpty || _districtController.text.isEmpty || _stateController.text.isEmpty) {
      Navigator.pop(context); // pop the loading circle
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.red,
            title: Center(
              child: Text(
                'Please fill out all fields before proceeding.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      );
      return; // Exit early if any field is empty
    }

    // Check if passwords match
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      Navigator.pop(context); // pop the loading circle
      passwordNotMatch();
      return;
    }


    // Attempt user creation
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      //add user details
      addUserDetails(
          _emailController.text.trim(),
          _usernameController.text.trim(),
          int.parse(_phoneController.text.trim()),
          int.parse(_postcodeController.text.trim()),
          _districtController.text.trim(),
          _stateController.text.trim(),
      );

      //

      Navigator.pop(context); // pop the loading circle
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // pop the loading circle
      if (e.code == 'invalid-email') {
        wrongEmailMessage();
      } else if (e.code == 'invalid-credential') {
        wrongPasswordMessage();
      }
    }
  }

  Future addUserDetails(String email, String username, int phoneNumber, int postcode,String district, String state) async {
    await FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'username': username,
      'phone number': phoneNumber,
      'postcode' : postcode,
      'district' : district,
      'state' : state,
    });

  }

  // Wrong email message
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              'Please provide a valid email address.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  // Wrong password message
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  // Password mismatch
  void passwordNotMatch() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              'Password don\'t match!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('lib/images/logo.png', height: 125),
                const SizedBox(height: 20),
                // Text: 'Let's create an account for you!'
                Text(
                  'Let\' create an account for you!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                // Email text field
                MyTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obsecureText: false,
                ),
                const SizedBox(height: 10),
                // Password text field
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obsecureText: true,
                ),

                const SizedBox(height: 10),
                // Confirm password text field
                MyTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  obsecureText: true,
                ),

                const SizedBox(height: 10),
                // Username text field
                MyTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  obsecureText: false,
                ),


                const SizedBox(height: 10),
                // Phone number text field
                MyTextField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  obsecureText: false,
                ),
                const SizedBox(height: 10),

                // postcode text field
                MyTextField(
                  controller: _postcodeController,
                  hintText: 'Postcode',
                  obsecureText: false,
                ),

                const SizedBox(height: 10),

                // district text field
                MyTextField(
                  controller: _districtController,
                  hintText: 'District',
                  obsecureText: false,
                ),

                const SizedBox(height: 10),

                // State text field
                MyTextField(
                  controller: _stateController,
                  hintText: 'State',
                  obsecureText: false,
                ),

                const SizedBox(height: 25),
                // Sign-up button
                MyButton(
                  text: "Sign Up",
                  onTap: signUserUp,
                ),
                const SizedBox(height: 40),
                // Or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Google sign-up button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google sign-up button
                    SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'lib/images/google.png'),
                  ],
                ),
                const SizedBox(height: 30),
                // Already have an account text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
