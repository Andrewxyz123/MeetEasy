import 'package:flutter/material.dart';
import 'package:frontend/controllers/BookingController.dart';
import '../controllers/loginController.dart';

class LoginPage extends StatelessWidget {
  // const LoginPage({super.key});
  // text field controller
  final companyIdController = TextEditingController();
  final employeeIdController = TextEditingController();
  final passwordController = TextEditingController();
  final LoginController loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.meeting_room_outlined,
                size: 64.0,
                color: theme.primaryColor, // Use primary color from theme
              ),
              SizedBox(height: 16.0),
              Text(
                'Meeting Room',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.primaryColor, // Modify color if necessary
                ),
              ),
              SizedBox(height: 32.0),
              TextField(
                controller: companyIdController,
                decoration: InputDecoration(
                  labelText: 'Company ID',
                  border: theme.inputDecorationTheme.border, // Use border style from theme
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: employeeIdController,
                decoration: InputDecoration(
                  labelText: 'Employee ID',
                  border: theme.inputDecorationTheme.border, // Use border style from theme
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: theme.inputDecorationTheme.border, // Use border style from theme
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // Handle login action
                  loginController.loginUser(
                    company_id: companyIdController.text,
                    employee_id: employeeIdController.text,
                    password: passwordController.text,
                    context: context,
                  );
                },
                style: theme.elevatedButtonTheme.style?.copyWith(
                  minimumSize: MaterialStateProperty.all(Size(double.infinity, 48.0)),
                ),
                child: Text(
                  'Login',
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text(
                      'Forgot Password?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor, // Match theme primary color
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      // Handle contact support
                    },
                    child: Text(
                      'Contact Support',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor, // Match theme primary color
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
