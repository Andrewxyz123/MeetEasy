import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:frontend/models/user.dart';
import 'package:http/http.dart' as http;

class LoginController {

  UserController userController = UserController();

  Future<void> loginUser({
    required String company_id,
    required String employee_id,
    required String password,
    required BuildContext context,
  }) async {
    print(company_id + employee_id + password);
    if (company_id.isEmpty || password.isEmpty || employee_id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both Company ID, Employee ID and password.')),
      );
      return;
    }

    try {
      // Replace with your backend URL
      final url = Uri.parse('$loginURL');

      // Create the request body
      final requestBody = jsonEncode({
        'companyloginid': "tech_admin",
        'employeeid': "EMP001",
        'password': "password123"
      });

      // Log the request body
      print('Request Body: $requestBody');

      // Send a POST request to the backend
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );
      print(response.body);

      if (response.statusCode == 200) {
        User loggedInUser = User.fromJson(jsonDecode(response.body));
        // Login successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful! Welcome, ${loggedInUser.fullname}.')),
        );

        // Navigate to the next page
        Navigator.pushReplacementNamed(context, '/dashboard', arguments: {'user': loggedInUser});
      } else {
        // Login failed
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${error['message']}')),
        );
      }
    } catch (error) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Could not connect to the server.')),
      );
    }
  }
}
