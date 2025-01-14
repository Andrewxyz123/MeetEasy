import 'dart:convert';
import 'package:intl/intl.dart';

class Company {
  int? id;
  String? name; // Name of the company
  String? industry; // Industry of the company
  DateTime? createdAt; // Timestamp when the company was created
  

  // Constructor
  Company({
    this.id,
    this.name,
    this.industry,
    this.createdAt,
  });

  // Factory method to create an instance from JSON data
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json["id"],
      name: json["name"],
      industry: json["industry"],
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null, // Parse the created_at timestamp
    );
  }

  // Convert the object to JSON (if needed for API sending)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'industry': industry,
      'created_at': createdAt?.toIso8601String(), // Convert DateTime to ISO string
    };
  }
}
