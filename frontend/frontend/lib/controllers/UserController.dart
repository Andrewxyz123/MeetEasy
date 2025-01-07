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

  // Future register({
  //   required String name,
  //   required String username,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     isLoading.value = true;
  //     var data = {
  //       'name': name,
  //       'username': username,
  //       'email': email,
  //       'password': password,
  //     };

  //     var response = await http.post(
  //       Uri.parse('${registerURL}'),
  //       headers: {
  //         'Accept': 'application/json',
  //       },
  //       body: data,
  //     );

  //     if (response.statusCode == 201) {
  //       isLoading.value = false;
  //       token.value = json.decode(response.body)['token'];

  //       final currentUserDataTemp = json.decode(response.body)['user'];
  //       final User currentUserTemp = User.fromJson(currentUserDataTemp);
  //       currentUser.value = currentUserTemp;
  //       print(currentUser.value);

  //       box.write('token', token.value);
  //       Get.offAll(() => const HomePage());
  //     } else {
  //       isLoading.value = false;
  //       Get.snackbar(
  //         'Error',
  //         json.decode(response.body)['message'],
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //       print(json.decode(response.body));
  //     }
  //   } catch (e) {
  //     isLoading.value = false;

  //     print(e.toString());
  //   }
  // }

  Future login({
    required String username,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'username': username,
        'password': password,
      };

      print(data);

      var response = await http.post(
        Uri.parse('${loginURL}'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];

        final currentUserDataTemp = json.decode(response.body)['user'];
        final User currentUserTemp = User.fromJson(currentUserDataTemp);
        currentUser.value = currentUserTemp;
        print(currentUser.value);

        box.write('token', token.value);
        // Get.offAll(() => const HomePage());
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;

      print(e.toString());
    }
  }

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

//   // get token
// Future<String> getToken() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   return pref.getString('token') ?? '';
// }

// // get user id
// Future<int> getUserId() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   return pref.getInt('userId') ?? 0;
// }
