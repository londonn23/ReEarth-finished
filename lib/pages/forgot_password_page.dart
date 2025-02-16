import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage ({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _emailController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

Future passwordReset() async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
    }on FirebaseAuthException catch (e) {
      print(e.code);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Error: ${e.message}"), // Show the specific error message
          );
        },
      );

    }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[300],

      appBar: AppBar(title: Text('',),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(size: 30),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const SizedBox(height:50),

                // logo
                Image.asset('lib/images/logo.png', height: 200,),
                /*
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                */

                const SizedBox(height:50),

                //Please enter your email address
                Text(
                  'Please enter your email address',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,

                  ),
                ),

                const SizedBox(height:25),

                // text field
                MyTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obsecureText: false,
                ),

                const SizedBox(height:25),

                //reset password button
                MaterialButton(
                    onPressed: passwordReset,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      padding: const EdgeInsets.all(25.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.blue],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),

                      child: Center(
                        child: Text("Reset Password",
                          style:  const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),),
                      ),
                    ),
                )

              ],
            ),
          ),
        ),
      ),

    );
  }
}