import 'dart:convert';
import 'package:intl/intl.dart';

class Room {
  int? id;
  int? branch_id;  // This corresponds to the `company_branches(id)` foreign key
  String? room_number;  // This corresponds to the unique room number
  String? room_type;  // E.g., conference, office
  String? description;
  int? capacity;  // Capacity of the room
  String? status;  // E.g., available, booked, etc.
  // DateTime? created_at;  // Timestamp when the room was created

  // Constructor
  Room({
    this.id,
    this.branch_id,
    this.room_number,
    this.room_type,
    this.description,
    this.capacity,
    this.status,
    // this.created_at,
  });

  // Factory method to create an instance from JSON data
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"],
      branch_id: json["branch_id"],
      room_number: json["room_number"],
      room_type: json["room_type"],
      description: json["description"],
      capacity: json["capacity"],
      status: json["status"],
      // created_at: DateTime.parse(json["created_at"]),  // Parse the created_at timestamp
    );
  }

  // Convert the object to JSON (if needed for API sending)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'room_number': room_number,
      'room_type': room_type,
      'description': description,
      'capacity': capacity,
      'status': status,
      // 'created_at': created_at?.toIso8601String(),  // Convert DateTime to ISO string]
    };
  }
}
