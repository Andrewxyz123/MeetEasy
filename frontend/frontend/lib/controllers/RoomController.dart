import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart';
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
      var response = await http.get(Uri.parse('${url}/rooms'), headers: {
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

  Future createRoom({
    required String? roomNumber,
    required String? roomType,
    required String? description,
    required int? capacity
  }) async {
    try {
      var data = {
        'roomNumber': roomNumber,
        'roomType': roomType,
        'description': description,
        'capacity': capacity,
      };
      
      print(data);

      var response = await http.post(
        Uri.parse('${roomURL}/createRoom'),
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

  Future updateRoom({
    required int RoomId,
    required String roomNumber,
    required String roomType,
    required String description,
    required String capacity,
  }) async {
    try {
      var data = {
        'roomId': RoomId,
        'roomNumber': roomNumber,
        'roomType': roomType,
        'description': description,
        'capacity': capacity,
      };

      var response = await http.post(
        Uri.parse('${roomURL}/updateStoryRoom/$RoomId'),
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

  Future deleteRoom(int RoomId) async {
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

}
