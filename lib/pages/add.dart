import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/components/my_button.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  _AddPageState() {
    _selectedVal = _categories[0];
  }

  final _categories = ["Glass", "Paper", "Plastic"];
  String? _selectedVal = "";

  final TextEditingController _addressController = TextEditingController();
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  String _currentAddress = "";

  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      return Future.error("Location services are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.subLocality}, ${place.country}";
        _addressController.text = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  File? _image;
  final picker = ImagePicker();

  Future getImageGallery() async {
    final PickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      }
    });
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
            "SALE LISTING",
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

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    _textTitle("Title", "Name of your item..."),
                    SizedBox(height: 16),
                    _dropDownMenu(),
                    SizedBox(height: 16),
                    _textPrice("Price", "Item's price"),
                    SizedBox(height: 16),
                    _textAddress("Adress", "Your adress..."),
                    SizedBox(height: 16),
                    _textDescription(),
                    SizedBox(height: 16),
                    _addImage(),
                    SizedBox(height: 20),

                    MyButton(onTap: (){}, text: "Submit"),

                    SizedBox(height: 25),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> _dropDownMenu() {
    return DropdownButtonFormField(
        value: _selectedVal,
        items: _categories
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ))
            .toList(),
        onChanged: (val) {
          setState(() {
            _selectedVal = val as String;
          });
        },
        icon:
        const Icon(Icons.arrow_drop_down_circle, color: Colors.lightGreen),
        decoration: InputDecoration(
            labelText: "Category",
            prefixIcon: Icon(Icons.category_rounded, color: Colors.lightGreen),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            )));
  }

  InkWell _addImage() {
    return InkWell(
      onTap: () {
        getImageGallery();
      },
      child: Container(
        height: 225,
        width: 325,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: _image != null
            ? Image.file(
          _image!.absolute,
          fit: BoxFit.cover,
        )
            : Center(
          child: Icon(
            Icons.add_photo_alternate,
            color: Colors.lightGreen,
            size: 30,
          ),
        ),
      ),
    );
  }

  TextFormField _textTitle(String title, String hintText) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: title,
          hintText: hintText,
          prefixIcon: Icon(
            Icons.menu_book_rounded,
            color: Colors.lightGreen,
          ),
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )),
    );
  }

  TextFormField _textPrice(String title, String hintText) {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: title,
            hintText: hintText,
            prefixIcon: Icon(
              Icons.price_change_rounded,
              color: Colors.lightGreen,
            ),
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
               ),
        ));
    }

  TextFormField _textAddress(String title, String hintText) {
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(
          labelText: title,
          hintText: "Your address...",
          prefixIcon: Icon(
            Icons.location_on_rounded,
            color: Colors.lightGreen,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              _currentLocation = await _getCurrentLocation();
              await _getAddressFromCoordinates();
            },
            color: Colors.lightGreen,
          ),
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )),
    );
  }

  TextFormField _textDescription() {
    return TextFormField(
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            labelText: "Description",
            hintText: "Write your description here...",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(
              Icons.description_rounded,
              color: Colors.lightGreen,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            )));
  }
}
