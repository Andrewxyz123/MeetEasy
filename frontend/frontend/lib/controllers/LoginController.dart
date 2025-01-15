import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/controllers/BookingController.dart';
import 'package:frontend/controllers/RoomController.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/room.dart';
import 'package:frontend/models/user.dart';
// import 'package:frontend/pages/login_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController {

  UserController userController = Get.put(UserController());
  RoomController roomController = RoomController();
  BookingController bookingController = BookingController();

  Future<void> logout(BuildContext context) async {
  }

  Future<void> loginUser({
    required String company_id,
    required String employee_id,
    required String password,
    required BuildContext context,
  }) async {
    // print(company_id + employee_id + password);

    // if (company_id.isEmpty || password.isEmpty || employee_id.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Please enter both Company ID, Employee ID and password.')),
    //   );
    //   return;
    // }

    try {
      // Replace with your backend URL
      final url = Uri.parse('$loginURL');

      // Create the request body
      final requestBody = jsonEncode({
        'companyloginid': "tech_admin",
        'employeeid': "EMP001",
        'password': "password123"
      });

      // print('Trying to login with request body: ' + requestBody);
      // Send a POST request to the backend
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );
      // print('Login response: ' + response.body);


      if (response.statusCode == 200) {
        // print('Trying to set logged-in user: ' + User.fromJson(jsonDecode(response.body)).toString());
        User loggedInUser = User.fromJson(jsonDecode(response.body));

        // print('Login successful: ' + loggedInUser.toString());  
        userController.setLoggedInUser(loggedInUser);

        // print('Fetching bookings for logged-in user...');
        List<Booking> bookingList = await bookingController.fetchBookingsForLoggedInUser();
        // print('Booking list: ' + bookingList.toString());
        List<Room> roomList = [];
        if (loggedInUser.role?.name?.toLowerCase() == 'room_manager') {
        roomList = await roomController.fetchRoomsForLoggedInUser2();
        // print('Rooms fetched successfully');
      }

        // Login successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful! Welcome, ${loggedInUser.fullname}.')),
        );

        // print('Fetching rooms for logged-in user...');
        await roomController.getAllRooms(); // Assuming this is an async function
        // print('Rooms fetched successfully');

        // Navigate to the next page
        Navigator.pushReplacementNamed(context, '/dashboard', arguments: 
        {'user': loggedInUser,
          'booking-list': bookingList,
          if (loggedInUser.role?.name?.toLowerCase() == 'room_manager') 'room-list': roomList,
        });
      } else {
        // Login failed
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${error['message']}')),
        );
      }
    } catch (error) {
      print('Error: $error');
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Could not connect to the server.')),
      );
    }
  }
}
