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
    List<int> createdAtList = List<int>.from(json['createdAt'] ?? []);
    return Company(
      id: json["id"],
      name: json["name"],
      industry: json["industry"],
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
      'name': name,
      'industry': industry,
      'createdAt': createdAt?.toIso8601String(), // Convert DateTime to ISO string
    };
  }
}
