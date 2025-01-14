import 'dart:convert';
import 'package:frontend/models/company_branch.dart';

class Room {
  int? id;
  int? branchId;  // This corresponds to the `company_branches(id)` foreign key
  String? roomNumber;  // This corresponds to the unique room number
  String? roomType;  // E.g., conference, office
  String? description;
  int? capacity;  // Capacity of the room
  String? status;  // E.g., available, booked, etc.
  CompanyBranch? companyBranch;
  DateTime? createdAt;

  // Constructor
  Room({
    this.id,
    this.branchId,
    this.roomNumber,
    this.roomType,
    this.description,
    this.capacity,
    this.status,
    this.companyBranch,
    this.createdAt,
  });

  // Factory method to create an instance from JSON data
  factory Room.fromJson(Map<String, dynamic> json) {
    List<int> createdAtList = List<int>.from(json['createdAt'] ?? []);
    return Room(
      id: json["id"],
      branchId: json["branch_id"],
      roomNumber: json["roomNumber"],
      roomType: json["roomType"],
      description: json["description"],
      capacity: json["capacity"],
      status: json["status"],
      companyBranch: json['branch'] != null ? CompanyBranch.fromJson(json['branch']) : null,
      createdAt: createdAtList.isNotEmpty ? DateTime(
        createdAtList[0], // year
        createdAtList[1], // month
        createdAtList[2], // day
        createdAtList[3], // hour
        createdAtList[4], // minute
        createdAtList[5], // second
      ) : null,
    );
  }

  // Convert the object to JSON (if needed for API sending)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'roomNumber': roomNumber,
      'roomType': roomType,
      'description': description,
      'capacity': capacity,
      'status': status,
      'branch': companyBranch?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
