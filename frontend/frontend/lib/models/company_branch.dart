import 'dart:convert';

class CompanyBranch {
  int? id; // Primary key
  int? companyId; // Foreign key referencing companies(id)
  String? name; // Name of the branch
  String? address; // Address of the branch
  String? contactNumber; // Contact number of the branch
  String? email; // Email of the branch
  // DateTime? createdAt; // Timestamp when the branch was created

  // Constructor
  CompanyBranch({
    this.id,
    this.companyId,
    this.name,
    this.address,
    this.contactNumber,
    this.email,
    // this.createdAt,
  });

  // Factory method to create an instance from JSON data
  factory CompanyBranch.fromJson(Map<String, dynamic> json) {
    return CompanyBranch(
      id: json["id"],
      companyId: json["company_id"],
      name: json["name"],
      address: json["address"],
      contactNumber: json["contact_number"],
      email: json["email"],
      // createdAt: json["created_at"] != null
      //     ? DateTime.parse(json["created_at"])
          // : null, // Parse the created_at timestamp
    );
  }

  // Convert the object to JSON (if needed for API sending)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'name': name,
      'address': address,
      'contact_number': contactNumber,
      'email': email,
      // 'created_at': createdAt?.toIso8601String(), // Convert DateTime to ISO string
    };
  }
}
