import 'dart:convert';

import 'package:frontend/models/company.dart';

class CompanyBranch {
  int? id; // Primary key
  Company? company; // Nested company object
  String? name; // Name of the branch
  String? address; // Address of the branch
  String? contactNumber; // Contact number of the branch
  String? email; // Email of the branch
  DateTime? createdAt; // Timestamp when the branch was created

  CompanyBranch({
    this.id,
    this.company,
    this.name,
    this.address,
    this.contactNumber,
    this.email,
    this.createdAt,
  });

  factory CompanyBranch.fromJson(Map<String, dynamic> json) {
    List<int> createdAtList = List<int>.from(json['createdAt'] ?? []);
    return CompanyBranch(
      id: json["id"],
      company: json["company"] != null ? Company.fromJson(json["company"]) : null,
      name: json["name"],
      address: json["address"],
      contactNumber: json["contactNumber"],
      email: json["email"],
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company?.toJson(),
      'name': name,
      'address': address,
      'contactNumber': contactNumber,
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}