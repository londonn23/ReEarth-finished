import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/my_button.dart';
import 'package:login/components/my_textfield.dart';
import 'package:login/components/square_tile.dart';
import 'package:login/pages/auth_service.dart';
import 'package:login/pages/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required  this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //SignUserIN method
  void signUserIn() async {

    // show loading circle
    showDialog(
      context: context,
      builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );

      // pop the loading circle since it is not pop away
      Navigator.pop(context);

    } on FirebaseAuthException catch (e){

      // pop the loading circle since it is not pop away
      Navigator.pop(context);

      //WRONG EMAIL
      if (e.code == 'invalid-email') {
        wrongEmailMessage();

        //WRONG PASSWORD
      } else if (e.code == 'invalid-credential') {
        wrongPasswordMessage();
      }
    }
  }

  //wrong email message popup
  void wrongEmailMessage(){
    showDialog(

        context: context,
        builder: (context){
          return const AlertDialog(
            backgroundColor: Colors.red,
            title: Center(
              child: Text('Incorrect Email',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
            ),
          );
        },

        );
  }

  //wrong password message popup
  void wrongPasswordMessage(){
    showDialog(
      context: context,
      builder: (context){
        return const AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text('Incorrect Password',style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),),
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
              children:  [
                const SizedBox(height:50),

                // logo
                Image.asset('lib/images/logo.png', height: 150,),
                /*
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                */

                const SizedBox(height:50),

                //welcome back, you've been missed!
                Text(
                  'Welcome back, You\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,

                  ),
                ),

                const SizedBox(height:25),

                //email text field
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obsecureText: false,
                ),

                const SizedBox(height:10),

                //password text field
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obsecureText: true,
                ),

                const SizedBox(height:10),

                //forgot password
                /*
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return ForgotPasswordPage();
                          }));
                        },
                        child: Text('Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
                */

                const SizedBox(height:25),

                //sign-in button
                MyButton(
                  text: "Sign In",
                  onTap: signUserIn,
                ),

                const SizedBox(height:50),

                //or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(child: Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                        ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Or continue with',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                          ),
                        ),

                        Expanded(child: Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                        ),
                        )
                      ],
                    ),
                  ),

                const SizedBox(height:50),

                // google sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google button
                    SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'lib/images/google.png'),
                  ],
                ),

                const SizedBox(height:50),

                //not a member? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(
                      'Not a member?',
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(width: 5),

                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                        'Register now',
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