// id SERIAL PRIMARY KEY,
//     company_id INT REFERENCES companies(id) ON DELETE CASCADE,
//     companyloginid VARCHAR(20) NOT NULL,         -- Unique login ID for each company
//     employeeid VARCHAR(20) NOT NULL,             -- Employee ID within the company
//     fullname VARCHAR(255) NOT NULL,              -- Full name of the user, does not have to be unique
//     password VARCHAR(255) NOT NULL,              -- Password stored securely
//     role_id INT REFERENCES roles(id),            -- Reference to role (e.g., room_manager)
//     status VARCHAR(20) DEFAULT 'active',
//     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
//     UNIQUE (companyloginid, employeeid)    
import 'package:frontend/models/company.dart';

class User {
  int? id;
  String? fullname;
  String? user_role;
  String? status;
  Company? company;
  // String? password;

  User({
    this.id,
    this.fullname,
    this.user_role,
    this.status,
    this.company,
    // this.password
    // this.token
  });


  // function to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      fullname: json['fullname'],
      status: json['status'],
      user_role: json['roleName'],
      company: json['company'] != null ? Company.fromJson(json['company']) : null, 
      // password: json['password']
      // token: json['token']
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "status": status,
        "user_role": user_role,
        "company": company,
        // "password": password,
      };
}