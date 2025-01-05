import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController {
  Future<void> loginUser({
    required String company_id,
    required String employee_id,
    required String password,
    required BuildContext context,
  }) async {
    if (company_id.isEmpty || password.isEmpty || employee_id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both Company ID, Employee ID and password.')),
      );
      return;
    }

    try {
      // Replace with your backend URL
      final url = Uri.parse('https://your-backend-url.com/api/login');

      // Send a POST request to the backend
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'company_id': company_id, 'employee_id': employee_id , 'password': password}),
      );

      if (response.statusCode == 200) {
        // Login successful
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful! Welcome, ${data['name']}.')),
        );

        // Navigate to the next page
        Navigator.pushReplacementNamed(context, '/dashboard');
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
        SnackBar(content: Text('Error: Could not connect to the server.')),
      );
    }
  }
}
