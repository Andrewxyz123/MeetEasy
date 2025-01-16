import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/controllers/UserController.dart';
import 'package:frontend/models/company_branch.dart';
import 'package:frontend/models/room.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class RoomController extends GetxController {

  Rx<List<Room>> Rooms = Rx<List<Room>>([]);
  final isLoading = false.obs;
  final box = GetStorage();

  // Rx<List<Room>> userRooms = Rx<List<Room>>([]);
  List<Room?> userRooms = [];

  @override
  void onInit() {
    // userRooms = [];
    // getAllRooms();
    super.onInit();
  }

  Future getAllRooms() async {
    try {
      userRooms = [];
      var response = await http.get(Uri.parse('$roomURL'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        final content = json.decode(response.body);
        // Parse each room and add to the userRooms list
        userRooms.addAll(
          (content as List).map((item) => Room.fromJson(item)).toList(),
        );
      } else {
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getRoomsByUserId(int userId) async {
    try {
      userRooms = [];

      // Construct the URL with userId
      var response = await http.get(
        Uri.parse('$roomURL/user/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        final content = json.decode(response.body);
        // Parse each room and add to the userRooms list
        userRooms.addAll(
          (content as List).map((item) => Room.fromJson(item)).toList(),
        );
      } else if (response.statusCode == 404) {
        // Handle case when no rooms are found
        final error = json.decode(response.body);
        print("Error: ${error['error']}");
      } else {
        // Handle other errors
        print("Error: ${response.statusCode}");
        print(json.decode(response.body));
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> fetchRoomsForLoggedInUser() async {
  final userController = Get.find<UserController>();
  final roomController = Get.find<RoomController>();

  final userId = userController.user?.id;

  if (userId == null) {
    print("Error: No logged-in user.");
    Get.snackbar(
      'Error',
      'No logged-in user found.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  // Call the method to get rooms by user ID
  await roomController.getRoomsByUserId(userId);
}

Future createRoom({
  required String? roomNumber,
  required String? roomType,
  required String? description,
  required int? capacity,
  required CompanyBranch? branch
}) async {
  try {
    // Create the request payload
    var data = {
      'roomNumber': roomNumber ?? '',
      'roomType': roomType ?? '',
      'description': description ?? '',
      'capacity': capacity ?? 0, // Server expects int for capacity
      'branch' : branch,
      'status': 'available'
    };

    print('Request Data: $data'); // Debugging print

    // Make the HTTP POST request
    var response = await http.post(
      Uri.parse('$roomURL/createRoom'),
      headers: {
        'Accept': 'application/json', // Expect JSON response
        'Content-Type': 'application/json', // Sending JSON data
        'Authorization': 'Bearer ${box.read('token')}', // Token for auth
      },
      body: json.encode(data), // Encode body as JSON
    );

    if (response.statusCode == 201) {
      // Successfully created the room
      print('Response: ${json.decode(response.body)}');
    } else {
      // Handle error responses
      print('Error: ${response.body}');
      Get.snackbar(
        'Error',
        json.decode(response.body)['message'] ?? 'Unknown error occurred',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    // Handle exceptions
    print('Exception: $e');
  }
}



//updateRoomById
  Future updateRoom({
    required int? roomId,
    required String? roomNumber,
    required String? roomType,
    required String? description,
    required int? capacity,
  }) async {
    try {
      var data = {
        'roomId': roomId,
        'roomNumber': roomNumber,
        'roomType': roomType,
        'description': description,
        'capacity': capacity,
      };

      var response = await http.post(
        Uri.parse('${roomURL}/updateStoryRoom/$roomId'),
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
      print('Error updating Room: $e');
    }
  }

//deleteRoomById
  Future deleteRoom(int? RoomId) async {
    try {
      var response = await http.post(
        Uri.parse('${roomURL}/deleteRoom/$RoomId'),
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
      print('Error deleting Room: $e');
    }
  }

    // Fetch bookings by user ID
  Future<List<Room>> getRoomsByUserId2(int userId) async {
    try {
      var response = await http.get(
        Uri.parse('$roomURL/user/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      print("Finding rooms for user $userId...");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final content = json.decode(response.body);
        if (content is List) {
          return content.map((item) => Room.fromJson(item)).toList();
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
  Future<List<Room>> fetchRoomsForLoggedInUser2() async {
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

    return await getRoomsByUserId2(userId);
  }

}
