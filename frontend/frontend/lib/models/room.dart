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

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"],
      branchId: json["branch_id"],
      roomNumber: json["roomNumber"],
      roomType: json["roomType"],
      description: json["description"],
      capacity: json["capacity"],
      status: json["status"],
      companyBranch: json['branch'] != null ? CompanyBranch.fromJson(json['branch']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null, // Parse the date string directly
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
