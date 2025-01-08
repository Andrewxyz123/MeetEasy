import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/room.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class BookingController extends GetxController {

  // Rx<List<Booking>> bookings = Rx<List<Booking>>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  List<Booking?> userBookings = [];

  @override
  void onInit() {
    // getAllBookings();
    // TaleController().getAllTags();
    super.onInit();
  }

  Future getAllBookings() async {
    try {
      userBookings = [];
      var response = await http.get(Uri.parse('${url}/bookings'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        final content = json.decode(response.body);
        userBookings.addAll(
          (content as List).map((item) => Booking.fromJson(item)).toList(),
        );
        print('hello');
      } else {
        // print('test');
        print(json.decode(response.body));
      }
    } catch (e) {
      // print('test');
      print(e.toString());
    }
  }

  Future createBooking({
    required Room? room,
    required DateTime? start_time,
    required DateTime? end_time,
    // required String description
  }) async {
    try {
      var data = {
        'start_time': start_time,
        'end_time': end_time,
      };
      
      print(data);

      var response = await http.post(
        Uri.parse('${roomURL}/createBooking'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        print(json.decode(response.body));
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateReel({
    required int reelId,
    required String updatedTitle,
    required String updatedContent,
  }) async {
    try {
      var data = {
        'title': updatedTitle,
        'content': updatedContent,
      };

      var response = await http.post(
        Uri.parse('${bookingURL}/updateStoryReel/$reelId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        onInit();
      } else {
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating reel: $e');
    }
  }

  Future deleteReel(int reelId) async {
    try {
      var response = await http.post(
        Uri.parse('${bookingURL}/deleteStoryReel/$reelId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 201) {
        onInit();
      } 
      // else {
      //   Get.snackbar(
      //     'Error',
      //     json.decode(response.body)['message'],
      //     snackPosition: SnackPosition.TOP,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white,
      //   );
      // }
    } catch (e) {
      print('Error deleting reel: $e');
    }
  }

}
