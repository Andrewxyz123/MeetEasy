import 'package:frontend/models/user.dart';
import 'package:frontend/models/company.dart';
import 'package:frontend/models/booking.dart';

// Dummy User
final User dummyUser = User(
  id: 1,
  fullname: "John Doe",
  user_role: "Employee",
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

// Dummy Bookings
final List<Booking> dummyUpcomingBookings = [
  Booking(
    id: 1,
    user_id: 1,
    room_id: 101,
    room_number: "A101",
    company_branch_name: "Jakarta HQ",
    start_time: DateTime(2025, 1, 14, 10, 0), // Tomorrow 10 AM
    end_time: DateTime(2025, 1, 14, 11, 0),   // Tomorrow 11 AM
    status: "approved"
  ),
  Booking(
    id: 2,
    user_id: 1,
    room_id: 102,
    room_number: "B202",
    company_branch_name: "Jakarta HQ",
    start_time: DateTime(2025, 1, 14, 14, 0), // Tomorrow 2 PM
    end_time: DateTime(2025, 1, 14, 15, 30),  // Tomorrow 3:30 PM
    status: "requested"
  ),
  Booking(
    id: 3,
    user_id: 1,
    room_id: 103,
    room_number: "C303",
    company_branch_name: "Jakarta HQ",
    start_time: DateTime(2025, 1, 15, 9, 0),  // Day after tomorrow 9 AM
    end_time: DateTime(2025, 1, 15, 10, 30),  // Day after tomorrow 10:30 AM
    status: "approved"
  ),
];
