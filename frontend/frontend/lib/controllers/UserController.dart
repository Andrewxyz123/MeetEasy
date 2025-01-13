import 'dart:convert';

import 'package:frontend/constants/constants.dart';
// import 'package:ceritaku/views/home.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/user.dart';

class UserController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;

  final box = GetStorage();

  final Rx<User?> currentUser = Rx<User?>(null);
  

  Future updateUser({
    required String fullname
  }) async {
    try {
      var data = {
        'fullname': fullname,
      };

      var response = await http.post(
        Uri.parse('${url}editUser'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      final currentUserDataTemp = json.decode(response.body)['user'];
      final User currentUserTemp = User.fromJson(currentUserDataTemp);
      currentUser.value = currentUserTemp;
      update();

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Error Unable to Update Profile',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating reel: $e');
    }
  }

  Future<bool> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    currentUser.value = null;
    return await pref.remove('token');
  }
  
}

