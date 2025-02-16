import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/my_button.dart';
import 'package:login/pages/contact_page.dart';

class TrashSelection extends StatefulWidget {
  const TrashSelection({super.key});


  @override
  State<TrashSelection> createState() => _TrashSelectionState();
}

class _TrashSelectionState extends State<TrashSelection> {
  Set<String> selectedCategories = {};
  bool isGlassToggled = false;
  bool isPaperToggled = false;
  bool isPlasticToggled = false;
  List<String> trashType = [
    "GLASS",
    "PAPER",
    "PLASTIC",
    "PLASTIC",
    "PAPER",
    "GLASS"
  ];

  List<String> imageLink = [
    'lib/images/glass1.jpg',
    'lib/images/glass2.jpg',
    'lib/images/paper1.jpg',
    'lib/images/paper2.jpg',
    'lib/images/plastic1.jpg',
    'lib/images/plastic2.jpg'
  ];

  List<String> nameList = [
    'Glass bottle',
    'Who want this?',
    'Anyone interested?',
    'Paper',
    'Plastic, Plastic, Plastic',
    'Plastic bottle to sell'
  ];

  List<String> priceList = [
    'RM 0.20 / kg',
    'RM 0.20 / kg',
    'RM 0.30 / kg',
    'RM 0.50 / kg',
    'RM 0.50 / kg',
    'RM 1.00 / kg'
  ];

  List<String> locationList = [
    'Nilai, Seremban',
    'Ipoh, Perak',
    'Tawau,Sabah',
    'Pasir Mas, Kelantan',
    'Kuching, Sarawak',
    'Batu Pahat, Johor'
  ];

  // signUserOut method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {
    List<String> filteredTrashType = selectedCategories.isEmpty
        ? trashType
        : trashType.where((type) => selectedCategories.contains(type)).toList();
    filteredTrashType.sort((a, b) => a.compareTo(b));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "MARKETPLACE",
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
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "CATEGORY:",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(54, 71, 42, 1.0), // categoryTitle
              ),
            ),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 3, color: Colors.black),
                color: Color.fromRGBO(197, 214, 185, 1.0), // categoryBox
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  TrashButton(
                    category: "GLASS",
                    isToggled: isGlassToggled,
                    onPressed: () {
                      setState(() {
                        isGlassToggled = !isGlassToggled;
                        if (selectedCategories.contains("GLASS")) {
                          selectedCategories.remove("GLASS");
                        } else {
                          selectedCategories.add("GLASS");
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TrashButton(
                    category: "PAPER",
                    isToggled: isPaperToggled,
                    onPressed: () {
                      setState(() {
                        isPaperToggled = !isPaperToggled;
                        if (selectedCategories.contains("PAPER")) {
                          selectedCategories.remove("PAPER");
                        } else {
                          selectedCategories.add("PAPER");
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TrashButton(
                    category: "PLASTIC",
                    isToggled: isPlasticToggled,
                    onPressed: () {
                      setState(() {
                        isPlasticToggled = !isPlasticToggled;
                        if (selectedCategories.contains("PLASTIC")) {
                          selectedCategories.remove("PLASTIC");
                        } else {
                          selectedCategories.add("PLASTIC");
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Text(
                "SEARCH RESULT",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(54, 71, 42, 1.0), // searchResultTitle
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ListView.builder(
                  itemCount: filteredTrashType.length,
                  itemBuilder: (context, index) {
                    return ItemListing(
                        trashType: filteredTrashType, index: index, imageLink: imageLink, nameList: nameList,priceList: priceList,locationList: locationList);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemListing extends StatelessWidget {
  final List<String> trashType;
  final List<String> imageLink;
  final List<String> nameList;
  final List<String> priceList;
  final List<String> locationList;
  final int index;
  const ItemListing({
    super.key,
    required this.trashType,
    required this.imageLink,
    required this.index,
    required  this.nameList,
    required  this.priceList,
    required  this.locationList,
  });

  // messageSeller method
  void messageSeller(BuildContext context) async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),


        );
      },
    );
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          height: 375,
          decoration: BoxDecoration(
              color: Color.fromRGBO(180, 202, 164, 1.0), // itemBoxBG
              border: Border.all(width: 4, color: Colors.green.shade800),
              borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Positioned(
                top: 5, // Adjust top position
                left: 20, // Adjust left position
                child: Image.asset(
                  imageLink[index], // Path to your image
                  width: 250, // Set image width
                  height: 200, // Set image height
                ),
              ),
              Positioned(
                  top: 210,
                  left: 20,
                  child: Text(
                    nameList[index],
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromRGBO(235, 241, 231, 1.0)), // itemTitle
                  )),
              Positioned(
                  top: 270,
                  left: 20,
                  child: Text(
                    priceList[index],
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromRGBO(235, 241, 231, 1.0)), // itemPrice
                  )),
              Positioned(
                  bottom: 0,
                  left: 20,
                  child: Text(
                    locationList[index],
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromRGBO(73, 97, 57, 1.0)), // itemLocation
                  )),
              Positioned(
                  top: 5,
                  right: 8,
                  child: Text(
                    trashType[index],
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromRGBO(235, 241, 231, 1.0)), // itemTitle
                  )),

              Positioned(
                  bottom: 15,
                  right: -8,
                  child:
                  MyButton(
                    text: "Message Seller",
                    onTap: () => messageSeller(context),
                  ),)
            ],
          ),
        ),
      ),
    );
  }
}

class TrashButton extends StatelessWidget {
  final String category;
  final bool isToggled;
  final Color defaultColor = Colors.white;
  final Color selectedColor = Color.fromARGB(255, 120, 247, 124);
  final VoidCallback onPressed;

  TrashButton(
      {super.key,
        required this.category,
        required this.onPressed,
        required this.isToggled});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          minimumSize: Size(180, 50),
          backgroundColor:
          isToggled ? Color.fromRGBO(96, 128, 75, 1.0) : Colors.white, // marketplaceAfterSelectionGradient1
          foregroundColor: Colors.black),
      child: Text(
        category,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
