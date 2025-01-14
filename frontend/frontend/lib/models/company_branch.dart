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
    return CompanyBranch(
      id: json["id"],
      company: json["company"] != null ? Company.fromJson(json["company"]) : null,
      name: json["name"],
      address: json["address"],
      contactNumber: json["contactNumber"],
      email: json["email"],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null, // Parse the date string directly
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