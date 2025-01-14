import 'package:flutter/material.dart';
import 'package:frontend/pages/booking_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/room_views/room_page.dart';
import 'pages/login_page.dart';
import 'pages/booking_views/create_booking.dart';
import 'pages/room_views/create_room.dart';
import 'package:frontend/pages/dashboard_page.dart';  // Add dashboard page import
import 'package:frontend/dummy_data.dart';  // Add dummy data import

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
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF4A5568)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF718096)),
          bodySmall: TextStyle(fontSize: 12, color: Color(0xFF718096)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4C51BF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          labelStyle: const TextStyle(color: Color(0xFF4C51BF)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4C51BF),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/room-list', // Change initial route to dashboard
      routes: {
        '/login': (context) => LoginPage(),
        '/profile': (context) => const ProfilePage(),
        '/create-booking': (context) => CreateBookingPage(),
        '/create-room': (context) => CreateRoomPage(),
        '/booking-list': (context) => BookingPage(),
        '/dashboard': (context) => DashboardPage( 
          company: dummyCompany,
          companyBranch: dummyBranch,
          upcomingBookings: dummyUpcomingBookings,
        ),
        '/room-list': (context) => RoomPage(),
      },
    );
  }
}
