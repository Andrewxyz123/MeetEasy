class Role {
  int? id; // Primary key
  String? name; // Unique name of the role (e.g., 'room_manager', 'employee')
  String? description; // Description of the role

  // Constructor
  Role({
    this.id,
    this.name,
    this.description,
  });

  // Factory method to create an instance from JSON data
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json["id"],
      name: json["name"],
      description: json["description"],
    );
  }

  // Convert the object to JSON (if needed for API sending)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
