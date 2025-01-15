import 'dart:convert';

import 'package:frontend/constants/constants.dart';
// import 'package:frontend/controllers/LoginController.dart';
// import 'package:frontend/pages/profile_page.dart';
// import 'package:ceritaku/views/home.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/user.dart';

class UserController {
  final isLoading = false.obs;
  final token = ''.obs;

  final box = GetStorage();

  var loggedInUser = Rxn<User>();

  // LoginController loginController = LoginController(); 

  void setLoggedInUser(User user) {
    loggedInUser.value = user;
  }

  User? get user => loggedInUser.value;
  
  


  Future updateUser({
    required String fullname,
    required BuildContext context,
  }) async {
    if (loggedInUser.value == null) {
      Get.snackbar(
        'Error',
        'User not logged in.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return; // Exit early if the user is not logged in
    }

    try {
      var data = {
        'fullname': fullname,
      };

      var response = await http.put(
        Uri.parse('${userURL}/${loggedInUser.value?.id}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
          'Content-Type': 'application/json', // Ensure the content type is set
        },
        body: json.encode(data), // Convert the data to JSON
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        
        User updatedUserData = User.fromJson(jsonDecode(response.body));

        this.setLoggedInUser(updatedUserData);

        Get.snackbar(
            'Success',
            json.decode(response.body)['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
        );

        (context as Element).markNeedsBuild();


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
      Get.snackbar(
        'Error',
        'An error occurred: $e', // Provide user-friendly feedback
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    loggedInUser.value = null;
    return await pref.remove('token');
  }
  
}
