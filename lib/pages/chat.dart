import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class MyElevatedButton extends StatefulWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;
  final bool buttonState;



  final LinearGradient buttonColour = const LinearGradient(colors: [
    Color.fromARGB(255, 186, 185, 185),
    Color.fromARGB(255, 247, 243, 243)
  ]);

  final LinearGradient selectedButtonColour = const LinearGradient(colors: [
    Color.fromARGB(255, 61, 243, 73),
    Color.fromARGB(255, 156, 243, 132)
  ]);
  const MyElevatedButton(
      {super.key,
        required this.onPressed,
        required this.child,
        required this.buttonState,
        this.borderRadius,
        this.width,
        this.height = 44.0,
        this.gradient = const LinearGradient(colors: [
          Color.fromARGB(255, 186, 185, 185),
          Color.fromARGB(255, 247, 243, 243)
        ])});

  @override
  State<MyElevatedButton> createState() => _MyElevatedButtonState();
}

class _MyElevatedButtonState extends State<MyElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          gradient: widget.buttonState
              ? widget.selectedButtonColour
              : widget.buttonColour,
          borderRadius: BorderRadius.circular(12),
          border: Border.all()),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: widget.child,
      ),
    );
  }
}

class BoldTextFormatter extends StatelessWidget {
  final String text;

  const BoldTextFormatter({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final RegExp boldPattern =
    RegExp(r'\*\*(.*?)\*\*'); // Regex to detect **text**
    final List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    boldPattern.allMatches(text).forEach((match) {
      // Add normal text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      // Add bold text
      spans.add(TextSpan(
        text: match.group(1), // Extract text inside **
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));

      lastMatchEnd = match.end;
    });

    // Add remaining text after last match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return Text.rich(
      TextSpan(children: spans),
      style: TextStyle(fontSize: 20),
    );
  }
}

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  bool glassState = false;
  bool plasticState = false;
  bool paperState = false;
  bool anySelected = false;

  String glassPrompt = "";
  String plasticPrompt = "";
  String paperPrompt = "";
  String prompt =
      "In short words, give a simple to follow step-by-step instruction on how to recycle the following items, give more than 5 steps";

  final apiKey = 'not that easy bro';
  String? response = "Generated text will be displayed here";

  Future<String?> talkWithGemini(String userInput) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
    final content = [Content.text(userInput)];
    final response = await model.generateContent(content);
    return response.text;
  }

  void _sendMessage() async {
    String userMessage = prompt;
    if (userMessage.isNotEmpty) {
      setState(() {
        response = "generating...";
      });
      String? botResponse = await talkWithGemini(userMessage);
      setState(() {
        response = botResponse ?? "Error";
      });
      prompt =
      "In short words, give a step-by-step (minimum 6 steps) instruction on how to recycle the following items";
    }
  }

  // signUserOut method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
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
                  "ECO ASSIST",
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
            body: Center(
              child: Column(
                children: [
                  SizedBox(height: 25,),
                  Text(
                    "What are you recycling?",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(235, 241, 231, 1.0)),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                              child: MyElevatedButton(
                                  buttonState: glassState,
                                  onPressed: () {
                                    setState(() {
                                      glassState = !glassState;
                                    });
                                  },
                                  child: Text("GLASS"))),
                          SizedBox(width: 20),
                          Expanded(
                              child: MyElevatedButton(
                                  buttonState: plasticState,
                                  onPressed: () {
                                    setState(() {
                                      plasticState = !plasticState;
                                    });
                                  },
                                  child: Text("PLASTIC"))),
                          SizedBox(width: 20),
                          Expanded(
                              child: MyElevatedButton(
                                  buttonState: paperState,
                                  onPressed: () {
                                    setState(() {
                                      paperState = !paperState;
                                    });
                                  },
                                  child: Text("PAPER"))),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 50)),
                  Padding(
                    padding: const EdgeInsets.only(left: 300, bottom: 8),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.blue],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all()),
                      child: TextButton(
                          onPressed: () {
                            if (glassState == true ||
                                paperState == true ||
                                plasticState == true) {
                              anySelected = true;
                              glassPrompt = glassState ? "\nGlass" : "";
                              paperPrompt = paperState ? "\nPaper" : "";
                              plasticPrompt = plasticState ? "\nPlastic" : "";
                              prompt +=
                                  glassPrompt + paperPrompt + plasticPrompt;
                              setState(() {
                                _sendMessage();
                                glassState = false;
                                paperState = false;
                                plasticState = false;
                              });
                            } else {
                              anySelected = false;
                            }
                          },
                          child: Text(
                            "Send",
                            style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),

                          )),
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromRGBO(180, 202, 164, 1.0)),
                    child: SingleChildScrollView(
                      child: BoldTextFormatter(text: response ?? ""),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 50)),
                ],
              ),
            ),
            backgroundColor: Color.fromRGBO(222, 232, 216, 1));

  }
}
