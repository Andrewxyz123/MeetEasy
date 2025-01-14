import 'package:frontend/models/user.dart';
import 'package:frontend/models/company.dart';

// Dummy User
final User dummyUser = User(
  id: 1,
  fullname: "John Doe",
  userRole: "Employee",
  status: "active",
);

// Dummy Company
final Company dummyCompany = Company(
  id: 1,
  name: "Tech Corp",
  industry: "Technology",
  createdAt: DateTime.now(),
);

// Dummy Branch
const String dummyBranch = "Jakarta HQ";
