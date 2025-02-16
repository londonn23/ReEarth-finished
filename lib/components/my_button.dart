import 'package:flutter/material.dart';


class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25.0),
        padding: const EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.blue],
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      
        child: Center(
          child: Text(text,
          style:  const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),),
        ),
      ),
    );
  }
}