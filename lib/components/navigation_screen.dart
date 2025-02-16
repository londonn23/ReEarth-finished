import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:login/pages/add.dart';
import 'package:login/pages/chat.dart';
import 'package:login/pages/profile.dart';
import 'package:login/pages/trash_selection.dart';


class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  // final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  final screens = [
    TrashSelection(),
    ChatBot(),
    AddPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.store, size: 30),
      Icon(Icons.chat_bubble, size: 30),
      Icon(Icons.add_box, size: 30),
      Icon(Icons.person_2_rounded, size: 30)
    ];

    return Container(
      color: Colors.green,
        child: ClipRect(
          child: SafeArea(
            top: false,
            child: Scaffold(
                extendBody: true,
                backgroundColor: Colors.lightGreen,
            
                //to change screen
                body: screens[index],
            
                //this part is to change the theme of navigation bar if clicked
                bottomNavigationBar: Theme(
                  data: Theme.of(context)
                      .copyWith(iconTheme: IconThemeData(color: Colors.white)),
                  // design of navigation bar
                  child: CurvedNavigationBar(
                    // key: navigationKey,
                    color: Colors.green,
                    buttonBackgroundColor: Colors.lightGreen,
                    backgroundColor: Colors.transparent,
                    height: 60,
                    animationCurve: Curves.easeInOut,
                    animationDuration: Duration(milliseconds: 450),
                    index: index,
                    items: items,
                    onTap: (index) => setState(() => this.index = index),
                  ),
                )),
          ),
        ));
  }
}
