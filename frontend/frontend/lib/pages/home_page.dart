import 'package:frontend/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/booking_page_static.dart';
import 'package:frontend/pages/calendar_page.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;
  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    BookingPage(),
    const CalendarPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MeetEasy',
          style: GoogleFonts.lobster( // Replace 'lobster' with your desired font
            textStyle: const TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        centerTitle: true,
      ),

      
      body: Center(
        child: _widgetOptions.elementAt(currentIndex),
      ),

      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
      //     shape: const CircleBorder(),
      //     onPressed: (){
      //      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ReelForm()));
      //   },
      //     child: Icon(Icons.add, color: Colors.white, size: size * 0.080),
          
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (val) {
            setState(() {
              currentIndex = val;
            });
        },
      ),
    );
  }
}
