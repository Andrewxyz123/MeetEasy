import 'package:flutter/material.dart';
import 'package:frontend/pages/booking_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart'; // Import the home page
import 'pages/booking_views/create_booking.dart';
import 'pages/create_room.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define a primary color
        scaffoldBackgroundColor: Colors.grey[100], // Background for all screens
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
          bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelStyle: TextStyle(color: Colors.blue),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/booking-list', // Start with the login page
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => const HomePage(),
        '/create-booking': (context) => CreateBookingPage(),
        '/create-room': (context) => CreateRoomPage(),
        '/booking-list': (context) => BookingPage(),
      },
    );
  }
}
