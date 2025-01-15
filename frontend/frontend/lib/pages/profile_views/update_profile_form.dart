import 'package:frontend/controllers/BookingController.dart';
import 'package:frontend/controllers/RoomController.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/room.dart';
// import 'package:frontend/pages/dashboard_page.dart';
// import 'package:frontend/pages/login_page.dart';
// import 'package:frontend/pages/profile_page.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:frontend/constants/constants.dart';

import 'package:get/get.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {

  final TextEditingController _nameController = TextEditingController();

  final UserController _userController = Get.find<UserController>();
  BookingController bookingController = BookingController();
  RoomController roomController = RoomController();


  bool _loading = false;
  List<Booking> bookingList = [];
  List<Room> roomList = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings(); // Fetch bookings on initialization
  }

  Future<void> _fetchBookings() async {
    try {
      // Fetch bookings and set the state
      final bookings = await bookingController.fetchBookingsForLoggedInUser();
      final rooms = await roomController.fetchRoomsForLoggedInUser2();
      setState(() {
        bookingList = bookings;
        roomList = rooms;
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching bookings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size.width;

    String? nameValue = _userController.user!.fullname;
    // String? passwordValue = _userController.currentUser.value?.password;

    _nameController.text = nameValue!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Profile',
          style: TextStyle(color: Colors.white), // Set title text color to white
        ),
        backgroundColor: const Color(0xFF4C51BF),
      ),

      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Form(child: Column(
                children: [
                  TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                      decoration: myInputDecoration('Name')
                  ),
                  // TextFormField(
                  //     keyboardType: TextInputType.name,
                  //     controller: _usernameController,
                  //     validator: (val) => val!.isEmpty ? 'Invalid Password' : null,
                  //     decoration: myInputDecoration('Username')
                  // ),
                  SizedBox(height: 30,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loading = true;
                        });
                        _userController.updateUser(fullname: _nameController.text.trim(), context: context);
                        _loading = false;
                        // Navigator.of(context).pushAndRemoveUntil(
                        //   MaterialPageRoute(builder: (context) => LoginPage()),
                        //   (Route<dynamic> route) => false,  // Remove all previous routes
                        // );
                        AlertDialog alert = AlertDialog(
                          title: Text("Update Profile"),
                          content: Container(
                            child: Text("Profile Succesfully Updated!"),
                          ),
                          
                          actions: [
                            TextButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacementNamed(context, '/dashboard', arguments: {'user': _userController.user,
                                 'booking-list': bookingList,
                                 if (_userController.user?.role?.name?.toLowerCase() == 'room_manager') 'room-list': roomList,
                                 });
                              },
                            ),
                          ],
                        );
                        showDialog(context: context, builder: (context) => alert);
                      },
                      child: Text('Edit Profile', style: GoogleFonts.montserrat(
                        fontSize: size * 0.040,
                        color: Colors.white,
                      ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}