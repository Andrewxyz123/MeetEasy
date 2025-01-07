import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/models/booking.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class BookingController extends GetxController {

  Rx<List<Booking>> bookings = Rx<List<Booking>>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  Rx<List<Booking>> userBookings = Rx<List<Booking>>([]);

  @override
  void onInit() {
    getAllPosts();
    getAllUserPosts();
    // TaleController().getAllTags();
    super.onInit();
  }

  Future getAllPosts() async {
    try {
      bookings.value.clear();
      isLoading.value = true;
      var response = await http.post(Uri.parse(bookingURL), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['reels'];
        for (var item in content) {
          bookings.value.add(Booking.fromJson(item));
          // print('test1');
        }
      } else {
        // print('test2');
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      // print('test3');
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future getAllUserPosts() async {
    try {
      userBookings.value.clear();
      isLoading.value = true;
      var response = await http.post(Uri.parse('${url}my-story-reel'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        isLoading.value = false;
        final content = json.decode(response.body)['reels'];
        for (var item in content) {
          userBookings.value.add(Booking.fromJson(item));
        }
      } else {
        isLoading.value = false;
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future createReels({
    required String title,
    required String content,
  }) async {
    try {
      var data = {
        'title': title,
        'content': content,
      };
      
      print(data);

      var response = await http.post(
        Uri.parse('${bookingURL}/createStoryReel'),
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
