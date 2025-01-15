import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/room.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class BookingController extends GetxController {
  final isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
  }

  // Fetch all bookings
  Future<List<Booking>> getAllBookings() async {
    try {
      var response = await http.get(Uri.parse('$url/bookings'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        final content = json.decode(response.body);
        return (content as List)
            .map((item) => Booking.fromJson(item))
            .toList();
      } else {
        print(json.decode(response.body));
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Fetch bookings by user ID
  Future<List<Booking>> getBookingsByUserId(int userId) async {
    try {
      var response = await http.get(
        Uri.parse('$bookingURL/user/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      print("Finding bookings for user $userId...");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final content = json.decode(response.body);
        if (content is List) {
          return content.map((item) => Booking.fromJson(item)).toList();
        } else {
          // Handle the case where the response is not a list
          print("Expected a list but got: $content");
          return [];
        }
      } else {
        print(json.decode(response.body));
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  // Fetch bookings for the logged-in user
  Future<List<Booking>> fetchBookingsForLoggedInUser() async {
    final userController = Get.find<UserController>();
    final userId = userController.user?.id;

    if (userId == null) {
      Get.snackbar(
        'Error',
        'No logged-in user found.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }

    return await getBookingsByUserId(userId);
  }

  // Create a booking
  Future<bool> createBooking({
    required Room? room,
    required DateTime? start_time,
    required DateTime? end_time,
  }) async {
    try {
      var data = {
        'start_time': start_time.toString(),
        'end_time': end_time.toString(),
      };

      var response = await http.post(
        Uri.parse('$bookingURL/createBooking'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Update a booking
  Future<bool> updateBooking({
    required int? bookingId,
    required Room? selectedRoom,
    required DateTime? startDateTime,
    required DateTime? endDateTime,
  }) async {
    try {
      var data = {
        'room': selectedRoom,
        'start_time': startDateTime.toString(),
        'end_time': endDateTime.toString(),
      };

      var response = await http.put(
        Uri.parse('$bookingURL/updateBooking/$bookingId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: json.encode(data),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating booking: $e');
      return false;
    }
  }

  // Delete a booking
  Future<bool> deleteBooking(int bookingId) async {
    try {
      var response = await http.delete(
        Uri.parse('$bookingURL/deleteBooking/$bookingId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting booking: $e');
      return false;
    }
  }

  // Update booking status
  Future<bool> updateBookingStatus({
    required int? bookingId,
    required String? status,
  }) async {
    try {
      var data = {
        'status': status,
      };

      var response = await http.put(
        Uri.parse('$bookingURL/updateBooking/$bookingId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: json.encode(data),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating booking status: $e');
      return false;
    }
  }
}
