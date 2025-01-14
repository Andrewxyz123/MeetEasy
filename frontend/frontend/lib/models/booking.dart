// -- Bookings Table
// CREATE TABLE IF NOT EXISTS bookings (
//     id SERIAL PRIMARY KEY,
//     user_id INT REFERENCES users(id) ON DELETE CASCADE,
//     room_id INT REFERENCES rooms(id) ON DELETE CASCADE,
//     start_time TIMESTAMP NOT NULL,
//     end_time TIMESTAMP NOT NULL,
//     status VARCHAR(20) DEFAULT 'requested',  -- E.g., requested, approved, declined
//     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
//     UNIQUE (room_id, start_time, end_time)  -- Ensures no overlapping bookings for the same room
// );

// import 'dart:convert';k

import 'package:frontend/models/room.dart';
import 'package:frontend/models/user.dart';

import 'package:intl/intl.dart';

// Booking postModelFromJson(String str) => Booking.fromJson(json.decode(str));

// String postModelToJson(Booking data) => json.encode(data.toJson());

class Booking {

  int? id;
  int? user_id;
  int? room_id;
  String? room_number;
  String? company_branch_name;
  DateTime? start_time; 
  DateTime? end_time;
  String? status;
  Room? room;
  User? user;

  //Need Room Number from Room
  
  //Need Company Branch Name

  Booking({
    this.id,
    this.user_id,
    this.room_id,
    this.room_number,
    this.company_branch_name,
    this.start_time,
    this.end_time,
    this.status,
    this.room,
    this.user
  });
  
  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
  id: json["id"],
  user_id: json["userId"],
  room_id: json['roomId'],
  room_number: json['roomNumber'],
  company_branch_name: json['companyBranchName'],
  start_time: DateTime.parse(json['startTime']),  // Parse the timestamp
  end_time: DateTime.parse(json['endTime']), 
  status: json['status'],
  room: json['room'] != null ? Room.fromJson(json['room']) : null,  // Parse the Room object
  user: json['user'] != null ? User.fromJson(json['user']) : null,    // Parse the User object
  );


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'room_id': room_id,
      'room_number': room_number,
      'company_branch_name': company_branch_name,
      'start_time': start_time?.toIso8601String(),
      'end_time': end_time?.toIso8601String(),
      'status': status,
      'room' : room,
      'user' : user
    };
  }

  String get formattedStartTime {
    return DateFormat('yyyy-MM-dd HH:mm').format(start_time ?? DateTime.now());
  }

  // Method to get formatted end time (e.g., '2025-01-10 14:00')
  String get formattedEndTime {
    return DateFormat('yyyy-MM-dd HH:mm').format(end_time ?? DateTime.now());
  }
}