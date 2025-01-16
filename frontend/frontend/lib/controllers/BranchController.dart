import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/company_branch.dart';
import 'package:frontend/models/room.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Branchcontroller extends GetxController {
  final isLoading = false.obs;
  final box = GetStorage();

// Example function to fetch branch by user ID (you may already have a similar method)
Future<List<CompanyBranch>> getBranchByUserId(int userId) async {
  try {
    var response = await http.get(
      Uri.parse('$branchURL/users/$userId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      },
    );

    print("Finding branches for user $userId...");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final content = json.decode(response.body);
      if (content is List) {
        return content.map((item) => CompanyBranch.fromJson(item)).toList();
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

Future<List<CompanyBranch>> fetchBranchForLoggedInUser() async {
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

  return await getBranchByUserId(userId);
}

  
}
